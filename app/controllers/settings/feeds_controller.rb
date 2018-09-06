class Settings::FeedsController < ::ApplicationController
  before_action :set_objects

  def index
    @feeds = scope.all.preload(:category)
  end

  def search
    skip_policy_scope

    return if request.get?

    @results = Feed::SearchService.call(params[:url])

    if @results.empty?
      flash.alert = t(".messages.no_result")
      redirect_to url_for
    end
  rescue Feed::SearchService::Error
    flash.alert = t(".messages.error")
    redirect_to url_for
  end

  def new
    @feed = scope.new(feed_params)
  end

  def create
    new

    if @feed.save
      flash.notice = t(".messages.ok")
      redirect_to back_url
    else
      render :new
    end
  end

  def show
    redirect_to action: :edit
  end

  def edit
  end

  def update
    if @feed.update(feed_params)
      flash.notice = t(".messages.ok")
      redirect_to back_url
    else
      render :edit
    end
  end

  def destroy
    @feed.destroy!
    flash.notice = t(".messages.ok")

    redirect_to back_url
  end

  private

  def model
    Feed
  end

  def back_url
    url_for(action: :index, id: nil)
  end

  def set_objects
    @feed = scope.find(params[:id]) if params.key?(:id)
  end

  def permitted_params
    [
      :name,
      :url,
      :category_id,
    ]
  end

  def feed_params
    params.fetch(:feed, {}).permit(permitted_params)
  end
end
