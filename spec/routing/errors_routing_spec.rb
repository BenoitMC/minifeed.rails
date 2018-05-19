require "rails_helper"

describe ErrorsController, type: :routing do
  describe "routing" do
    it "#not_found" do
      expect(get "/invalid").to route_to("errors#not_found", path: "invalid")
    end
  end
end
