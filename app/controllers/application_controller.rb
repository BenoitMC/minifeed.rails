class ApplicationController < ActionController::Base
  include AuthControllerConcern
  include Pundit::Authorization

  before_action :authenticate_user!

  after_action :verify_policy_scoped

  rescue_from ActionController::InvalidAuthenticityToken, with: :render_invalid_authenticity_token
  rescue_from ActionController::UnknownFormat, with: :render_not_acceptable
  rescue_from ActiveRecord::RecordNotFound, with: :render_not_found

  layout lambda {
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
    render template, status: :unprocessable_content
  end

  def render_invalid_authenticity_token
    flash.alert = t("errors.invalid_authenticity_token")
    redirect_to main_app.root_path
  end

  def scope
    policy_scope(model).all
  end
end
