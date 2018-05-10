class Settings::OpmlImportsController < ApplicationController
  def new
    authorize Feed, :create?
    skip_policy_scope
  end

  def create
    new

    if params[:file].blank?
      flash[:danger] = t(".messages.no_file")
      redirect_to action: :new
      return
    end

    OpmlImportService.call(current_user, params[:file].read)
    flash[:success] = t(".messages.ok")
    redirect_to main_app.settings_root_path
  end
end
