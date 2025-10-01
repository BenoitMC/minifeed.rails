class Settings::OpmlImportsController < ApplicationController
  skip_after_action :verify_policy_scoped

  def new; end

  def create
    new

    if params[:file].blank?
      flash.alert = t(".messages.no_file")
      redirect_to action: :new
      return
    end

    OpmlImportService.call(current_user, params[:file].read)
    flash.notice = t(".messages.ok")
    redirect_to main_app.settings_root_path
  end
end
