require "rails_helper"

RSpec.describe HomeController, type: :controller do
  describe "#home" do
    it "should be ok" do
      get :home
      expect(response).to be_ok
    end
  end
end
