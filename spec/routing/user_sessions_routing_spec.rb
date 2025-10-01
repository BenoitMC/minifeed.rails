require "rails_helper"

describe UserSessionsController, type: :routing do
  describe "routing" do
    it "#new" do
      expect(get("/user_session/new")).to route_to("user_sessions#new")
    end

    it "#create" do
      expect(post("/user_session")).to route_to("user_sessions#create")
    end

    it "#destroy" do
      expect(delete("/user_session")).to route_to("user_sessions#destroy")
    end
  end
end
