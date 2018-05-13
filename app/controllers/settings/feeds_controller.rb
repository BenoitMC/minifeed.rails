class Settings::FeedsController < ::ApplicationController
  before_action :set_objects

  def index
    authorize model, :list?

    @feeds = scope.all.preload(:category)
  end

  def search
    authorize model, :create?
    skip_policy_scope

    return if request.get?

    @results = Feed::SearchService.call(params[:url])
  end

  def new
    @feed = scope.new(feed_params)

    authorize @feed, :create?
  end

  def create
    new

    if @feed.save
      flash[:success] = t(".messages.ok")
      redirect_to back_url
    else
      render :new
    end
  end

  def show
    authorize @feed, :update?

    redirect_to action: :edit
  end

  def edit
    authorize @feed, :update?
  end

  def update
    authorize @feed, :update?

    if @feed.update(feed_params)
      flash[:success] = t(".messages.ok")
      redirect_to back_url
    else
      render :edit
    end
  end

  def destroy
    authorize @feed, :delete?

    @feed.destroy!
    flash[:success] = t(".messages.ok")

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
