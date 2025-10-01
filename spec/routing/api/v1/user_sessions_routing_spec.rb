require "rails_helper"

describe Api::V1::UserSessionsController, type: :routing do
  describe "routing" do
    it "#create" do
      expect(post("/api/v1/user_sessions")).to route_to("api/v1/user_sessions#create")
    end
  end
end
