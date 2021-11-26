require "rails_helper"

describe Api::V1::HomeController do
  render_views

  describe "#home" do
    it "should be ok" do
      sign_in create(:user)
      get :home
      expect(response).to be_ok
    end

    it "should be forbidden" do
      get :home
      expect(response).to be_unauthorized
    end

    it "should auth by bearer token and return current_user" do
      user = create(:user)
      request.headers["Authorization"] = "Bearer #{user.auth_token}"
      get :home
      expect(response).to be_ok
      expect(controller.send :current_user).to eq user
      expect(json_response["current_user"]["email"]).to eq user.email
    end

    it "should not auth by nil token" do
      user = create(:user)
      user.update_columns(auth_token: nil)
      request.headers["Authorization"] = "Bearer #{user.auth_token}"
      get :home
      expect(controller.send :current_user).to eq nil
    end

    it "should not auth by blank token" do
      user = create(:user)
      user.update_columns(auth_token: "")
      request.headers["Authorization"] = "Bearer #{user.auth_token}"
      get :home
      expect(controller.send :current_user).to eq nil
    end

    it "should return nav" do
      sign_in create(:user)
      expect(GenerateNavService).to receive(:call).and_return("the nav")
      get :home
      expect(json_response["nav"]).to eq "the nav"
    end
  end # describe "#home"
end
