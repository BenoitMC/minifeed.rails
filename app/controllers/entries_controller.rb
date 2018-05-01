class EntriesController < ApplicationController
  def index
    authorize Entry, :list?

    @entries = scope.all
      .preload(feed: :category)
      .page(params[:page]).per(100)
  end

  private

  def model
    Entry
  end
end
