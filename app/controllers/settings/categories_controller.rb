class Settings::CategoriesController < ApplicationController
  before_action :set_objects

  def index; end

  def show
    redirect_to action: :edit
  end

  def new
    @category = scope.new(category_params)
  end

  def edit; end

  def create
    new

    if @category.save
      flash.notice = t(".messages.ok")
      redirect_to back_url
    else
      render_error :new
    end
  end

  def update
    if @category.update(category_params)
      flash.notice = t(".messages.ok")
      redirect_to back_url
    else
      render_error :edit
    end
  end

  def destroy
    if @category.feeds.any?
      flash.alert = t(".messages.not_empty")
      redirect_to back_url
      return
    end

    @category.destroy!
    flash.notice = t(".messages.ok")

    redirect_to back_url
  end

  def reorder
    return if request.get?

    ApplicationRecord.transaction do
      params.permit(category: %i[id position])[:category].each_value do |category|
        scope.find(category[:id]).update!(category)
      end
    end

    flash.notice = t(".messages.ok")

    redirect_to back_url
  end

  private

  def model
    Category
  end

  def back_url
    url_for(action: :index, id: nil)
  end

  def set_objects
    @categories = scope.all
    @category = scope.find(params[:id]) if params.key?(:id)
  end

  def permitted_params
    [
      :name,
    ]
  end

  def category_params
    params.fetch(:category, {}).permit(permitted_params)
  end
end
