class EntriesController < ApplicationController
  before_action :set_entry

  def index
    authorize Entry, :list?

    @filter = Entry::Filter.new(scope, params)

    @entries = @filter.call
      .preload(feed: :category)
      .page(params[:page]).per(100)
  end

  def show
    authorize @entry, :read?

    @entry.update!(is_read: true) if @entry.is_unread?
  end

  def update
    authorize @entry, :update?

    if @entry.update(entry_params)
      render :show
    else
      render inline: "Error."
    end
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
