require "rails_helper"

describe HomeController do
  describe "#home" do
    it "should be redirect to entries" do
      sign_in create(:user)
      get :home
      expect(response).to redirect_to entries_path
    end
  end
end
