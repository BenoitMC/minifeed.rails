class HomeController < ApplicationController
  def home
    skip_authorization
    skip_policy_scope
    redirect_to entries_path
  end
end
