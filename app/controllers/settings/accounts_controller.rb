class Settings::AccountsController < ApplicationController
  skip_after_action :verify_policy_scoped

  def edit
    @user = current_user

    authorize @user, :update?
  end

  def update
    edit

    if @user.update(user_params)
      flash[:success] = t(".messages.ok")
      redirect_to main_app.settings_root_path
    else
      render :edit
    end
  end

  private

  def permitted_params
    [
      :email,
      :password,
    ]
  end

  def user_params
    user_params = params.fetch(:user, {}).permit(permitted_params)
    user_params.delete(:password) if user_params[:password].blank?
    user_params
  end
end