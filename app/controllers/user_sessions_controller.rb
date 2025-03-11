class UserSessionsController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[new create]
  skip_after_action :verify_policy_scoped
  before_action :redirect_if_signed_in, only: %i[new create]

  def new
  end

  def create
    user = User.find_by(email: params[:email])&.authenticate(params[:password])

    if user
      sign_in user, remember_me: params[:remember_me].to_i == 1
      flash.notice = t(".success")
      redirect_to root_path
    else
      flash.now.alert = t(".error")
      render_error :new
    end
  end

  def destroy
    sign_out
    flash.notice = t(".success")
    redirect_to root_path
  end

  private

  def redirect_if_signed_in
    redirect_to root_path if current_user
  end
end
