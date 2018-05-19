class Api::V1::HomeController < Api::V1::ApplicationController
  def home
    skip_policy_scope
    render_json
  end
end
