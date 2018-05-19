class Api::V1::UserSessionsController < Api::V1::ApplicationController
  skip_before_action :authenticate_user!
  skip_after_action  :verify_policy_scoped

  def create
    @user = User.find_by(email: params[:email])

    if @user&.valid_password?(params[:password])
      sign_in @user
      render_json
    else
      render_json_error "Invalid email and/or password."
    end
  end
end
