class Api::V1::EntriesController < Api::V1::ApplicationController
  before_action :set_entry

  def index
    @entries = EntriesFilter.call(scope, params)
      .preload(feed: :category)
      .page(params[:page]).per(100)

    render_json entries: @entries
  end

  def update
    if @entry.update(entry_params)
      render_json entry: @entry
    else
      render_json_error @entry
    end
  end

  def mark_all_as_read
    @entries = EntriesFilter.call(scope, params)
    @entries.update_all(is_read: true) # rubocop:disable Rails/SkipsModelValidations

    render_json entries: @entries
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
