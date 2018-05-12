class Settings::CategoriesController < ApplicationController
  before_action :set_objects

  def index
    authorize model, :list?
  end

  def new
    @category = scope.new(category_params)

    authorize @category, :create?
  end

  def create
    new

    if @category.save
      flash[:notice] = t(".messages.ok")
      redirect_to back_url
    else
      render :new
    end
  end

  def show
    authorize @category, :update?

    redirect_to action: :edit
  end

  def edit
    authorize @category, :update?
  end

  def update
    authorize @category, :update?

    if @category.update(category_params)
      flash[:notice] = t(".messages.ok")
      redirect_to back_url
    else
      render :edit
    end
  end

  def destroy
    authorize @category, :delete?

    @category.destroy!
    flash[:notice] = t(".messages.ok")

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
