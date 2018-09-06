class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  include Pundit

  before_action :authenticate_user!

  after_action :verify_policy_scoped, unless: -> {
    params[:controller].to_s.match(/^(devise)/)
  }

  rescue_from ActionController::InvalidAuthenticityToken do
    flash.alert = t("errors.invalid_authenticity_token")
    redirect_to main_app.root_path
  end

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
    render "errors/not_found.html", status: :not_found
  end

  def model
    raise NotImplementedError
  end

  def scope
    policy_scope(model)
  end
end
