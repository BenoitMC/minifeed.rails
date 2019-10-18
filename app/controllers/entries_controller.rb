class EntriesController < ApplicationController
  before_action :set_entry

  def index
    @filter = EntriesFilter.new(scope, params)

    @entries = @filter.call
      .preload(feed: :category)
      .page(params[:page]).per(Minifeed.config.entries_per_page)
  end

  def new
    skip_policy_scope
  end

  def create
    new

    begin
      Entry::CreateFromUrlService.call(params[:url], user: current_user)
      flash.notice = t(".messages.ok")
    rescue HttpClient::Error
      flash.alert = t(".messages.error")
    end

    redirect_to action: :index, type: :starred
  end

  def show
    @entry.update!(is_read: true) if @entry.is_unread?
  end

  def reader
    @html = Entry::GenerateReaderContentService.call(@entry)

    render layout: false
  end

  def iframe
    if CheckFramePermissionService.call(@entry.url)
      redirect_to @entry.url
    else
      @html = t(".not_allowed")
      render :reader, layout: false
    end
  rescue CheckFramePermissionService::Error
    @html = t(".http_error")
    render :reader, layout: false
  end

  def update
    if @entry.update(entry_params)
      render :show
    else
      render inline: "Error."
    end
  end

  def mark_all_as_read
    @filter = EntriesFilter.new(scope, params)
    @entries = @filter.call
    @entries.unread.update_all(is_read: true) # rubocop:disable Rails/SkipsModelValidations

    redirect_to action: :index, **@filter.to_h
  end

  private

  def model
    Entry
  end

  def set_entry
    @entry = scope.find(params[:id]) if params.key?(:id)
  end

  def permitted_params
    [
      :is_read,
      :is_starred,
    ]
  end

  def entry_params
    params.fetch(:entry, {}).permit(permitted_params)
  end
end
