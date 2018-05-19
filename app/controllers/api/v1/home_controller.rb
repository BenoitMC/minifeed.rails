class Api::V1::HomeController < Api::V1::ApplicationController
  def home
    skip_policy_scope

    nav = GenerateNavService.call(current_user)

    render_json nav: nav
  end
end
