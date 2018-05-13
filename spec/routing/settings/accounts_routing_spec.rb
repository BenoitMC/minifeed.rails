require "rails_helper"

describe Settings::AccountsController, type: :routing do
  describe "routing" do
    it "#edit" do
      expect(get "/settings/account/edit").to route_to("settings/accounts#edit")
    end

    it "#update" do
      expect(patch "/settings/account").to route_to("settings/accounts#update")
    end
  end
end
