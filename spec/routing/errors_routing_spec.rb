require "rails_helper"

describe ErrorsController, type: :routing do
  describe "routing" do
    it "#not_found" do
      expect(get "/invalid").to route_to("errors#not_found", path: "invalid")
    end

    it "#not_found xml" do
      expect(get "/invalid.xml").to route_to("errors#not_found", path: "invalid", format: "xml")
    end
  end
end
