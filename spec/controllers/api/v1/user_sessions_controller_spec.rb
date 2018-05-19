require "rails_helper"

describe Api::V1::UserSessionsController do
  render_views

  let!(:user) { create(:user, email: "user@example.org") }

  describe "#create" do
    it "should return user" do
      post :create, params: {email: "user@example.org", password: "password"}
      expect(response).to be_ok
      expect(json_response["current_user"]["auth_token"]).to eq user.auth_token
    end

    it "should fail on invalid email" do
      post :create, params: {email: "invalid@example.org", password: "invalid"}
      expect(response.code).to eq "422"
      expect(json_response["current_user"]).to eq nil
      expect(json_response["error"]).to eq "Invalid email and/or password."
    end

    it "should fail on invalid password" do
      post :create, params: {email: "user@example.org", password: "invalid"}
      expect(response.code).to eq "422"
      expect(json_response["current_user"]).to eq nil
      expect(json_response["error"]).to eq "Invalid email and/or password."
    end
  end # describe "#create"
end
