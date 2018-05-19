class Api::V1::ApplicationController < ApplicationController
  include Agilibox::ApiControllerConcern

  skip_before_action :verify_authenticity_token

  private

  def authenticate_user!
    return if current_user

    token = request.headers["X-Auth-Token"].presence

    if token && (user = User.find_by(auth_token: token))
      sign_in user
    else
      render_forbidden_or_unauthorized
    end
  end
end
