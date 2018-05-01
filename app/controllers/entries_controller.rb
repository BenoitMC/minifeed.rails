class EntriesController < ApplicationController
  def index
    authorize Entry, :list?

    @entries = scope.all
      .preload(feed: :category)
      .page(params[:page]).per(100)

    if (category_id = params[:category_id].presence)
      @entries = @entries.with_category_id(category_id)
    end

    if params[:starred].to_i == 1
      @entries = @entries.starred
    end
  end

  private

  def model
    Entry
  end
end
