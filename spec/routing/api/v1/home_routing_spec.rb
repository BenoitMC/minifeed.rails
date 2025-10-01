require "rails_helper"

describe Api::V1::HomeController, type: :routing do
  describe "routing" do
    it "#home" do
      expect(get("/api/v1")).to route_to("api/v1/home#home")
    end
  end
end
