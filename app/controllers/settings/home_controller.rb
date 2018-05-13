class Settings::HomeController < ApplicationController
  def home
    skip_policy_scope
  end
end
