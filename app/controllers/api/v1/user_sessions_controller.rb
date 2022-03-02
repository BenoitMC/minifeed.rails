class Api::V1::UserSessionsController < Api::V1::ApplicationController
  skip_before_action :authenticate_user!
  skip_after_action  :verify_policy_scoped

  def create
    email    = params[:email].to_s.strip
    password = params[:password].to_s.strip

    @user = User.find_by(email:)

    if @user&.valid_password?(password)
      sign_in @user
      render_json
    else
      render_json_error t(".invalid_email_or_password")
    end
  end
end
