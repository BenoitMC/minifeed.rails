class Settings::HomeController < ApplicationController
  def home
    skip_authorization
    skip_policy_scope
  end
end
