require "rails_helper"

describe StaticPagesController do
  before do
    sign_in create(:user)
  end

  render_views

  describe "#keyboard_shortcuts" do
    it "should be ok" do
      get :keyboard_shortcuts
      expect(response).to be_ok
    end
  end
end
