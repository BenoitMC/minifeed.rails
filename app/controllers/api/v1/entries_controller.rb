class Api::V1::EntriesController < Api::V1::ApplicationController
  before_action :set_entry

  def index
    @entries = EntriesFilter.call(scope, params.permit!)
      .page(params[:page]).per(Minifeed.config.entries_per_page)

    render_json entries: @entries, is_last_page: @entries.last_page?
  end

  def create
    skip_policy_scope

    if Entry::CreateFromUrlService.call(params[:url], user: current_user)
      render_json
    else
      render_json_error t(".messages.error")
    end
  end

  def update
    if @entry.update(entry_params)
      render_json entry: @entry
    else
      render_json_error @entry
    end
  end

  def mark_all_as_read
    EntriesFilter.call(scope, params.permit!)
      .unread
      .update_all(is_read: true) # rubocop:disable Rails/SkipsModelValidations

    index
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
