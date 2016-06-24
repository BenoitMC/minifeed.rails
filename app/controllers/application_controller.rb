class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  include Pundit

  before_action :authenticate_user!

  after_action :verify_authorized, unless: -> {
    params[:controller].to_s.match(/^(devise|rails_admin)/)
  }

  rescue_from ActionController::InvalidAuthenticityToken do
    flash[:alert] = t("errors.invalid_authenticity_token")
    redirect_to main_app.root_path
  end
end
