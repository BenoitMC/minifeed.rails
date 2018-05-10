require "rails_helper"

describe Settings::HomeController, type: :routing do
  describe "routing" do
    it "#home" do
      expect(get "/settings").to route_to("settings/home#home")
    end
  end
end
