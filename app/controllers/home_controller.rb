class HomeController < ApplicationController
  def home
    skip_authorization
  end
end
