require "rails_helper"

describe Settings::HomeController do
  describe "#home" do
    it "should be ok" do
      sign_in create(:user)
      get :home
      expect(response).to be_ok
    end
  end
end
