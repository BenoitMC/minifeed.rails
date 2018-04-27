class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  include Pundit

  before_action :authenticate_user!

  after_action :verify_authorized, unless: -> {
    params[:controller].to_s.match(/^(devise|rails_admin)/)
  }

  after_action :verify_policy_scoped, unless: -> {
    params[:controller].to_s.match(/^(devise|rails_admin)/)
  }

  rescue_from ActionController::InvalidAuthenticityToken do
    flash[:alert] = t("errors.invalid_authenticity_token")
    redirect_to main_app.root_path
  end

  rescue_from ActiveRecord::RecordNotFound, with: :render_not_found

  helper Agilibox::AllHelpers

  private

  def render_not_found
    render "errors/not_found", status: :not_found
  end
end
