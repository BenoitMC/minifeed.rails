class StaticPagesController < ApplicationController
  def keyboard_shortcuts
    skip_authorization
    skip_policy_scope
  end
end
