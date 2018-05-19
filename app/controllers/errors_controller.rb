class ErrorsController < ApplicationController
  skip_before_action :authenticate_user!
  skip_after_action  :verify_policy_scoped

  def not_found
    render_not_found
  end
end
