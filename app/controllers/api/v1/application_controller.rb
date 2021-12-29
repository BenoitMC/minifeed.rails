class Api::V1::ApplicationController < ApplicationController
  include BMC::ApiControllerConcern

  skip_before_action :verify_authenticity_token

  private

  def authenticate_user!
    return if current_user

    if bearer_token && (user = User.find_by(auth_token: bearer_token))
      sign_in user
    else
      render_forbidden_or_unauthorized
    end
  end

  def bearer_token
    authenticate_with_http_token { |token| return token }
  end
end
