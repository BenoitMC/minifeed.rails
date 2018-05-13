class Settings::CategoriesController < ApplicationController
  before_action :set_objects

  def index
  end

  def new
    @category = scope.new(category_params)
  end

  def create
    new

    if @category.save
      flash[:success] = t(".messages.ok")
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
    if @category.update(category_params)
      flash[:success] = t(".messages.ok")
      redirect_to back_url
    else
      render :edit
    end
  end

  def destroy
    @category.destroy!
    flash[:success] = t(".messages.ok")

    redirect_to back_url
  end

  def reorder
    return if request.get?

    params_array = params.permit(category: [:id, :position])[:category].values
    Agilibox::CollectionUpdate.new(scope, params_array).update!
    flash[:success] = t(".messages.ok")

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
