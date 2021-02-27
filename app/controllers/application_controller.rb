class ApplicationController < ActionController::Base
  include Pundit

  before_action :authenticate_user!

  after_action :verify_policy_scoped, unless: -> {
    params[:controller].to_s.match(/^(devise)/)
  }

  rescue_from ActionController::InvalidAuthenticityToken, with: :render_invalid_authenticity_token
  rescue_from ActionController::UnknownFormat, with: :render_not_acceptable
  rescue_from ActiveRecord::RecordNotFound, with: :render_not_found

  helper Agilibox::AllHelpers

  layout -> {
    if request.xhr? && params[:layout].to_s != "true"
      false
    else
      "application"
    end
  }

  private

  def render_not_found
    render "errors/not_found", formats: :html, status: :not_found
  end

  def render_not_acceptable
    head :not_acceptable
  end

  def render_error(template)
    render template, status: :unprocessable_entity
  end

  def render_invalid_authenticity_token
    flash.alert = t("errors.invalid_authenticity_token")
    redirect_to main_app.root_path
  end

  def scope
    policy_scope(model).all
  end

  def ensure_user_is_admin!
    unless current_user&.is_admin?
      flash.alert = t("errors.not_admin")
      redirect_to root_path
    end
  end
end
