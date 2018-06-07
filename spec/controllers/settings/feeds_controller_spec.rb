require "rails_helper"

describe Settings::FeedsController do
  let(:user) { create(:user) }

  before { sign_in user }

  render_views

  describe "#index" do
    it "should not include import error warning" do
      feed = create(:feed, user: user, import_errors: 0)
      get :index
      expect(response).to be_ok
      expect(response.body).to_not include "exclamation-triangle"
    end

    it "should include import error warning" do
      feed = create(:feed, user: user, import_errors: 42)
      get :index
      expect(response).to be_ok
      expect(response.body).to include "exclamation-triangle"
    end
  end # describe "#index"

  describe "#edit" do
    it "should not include import error warning" do
      feed = create(:feed, user: user, import_errors: 0)
      get :edit, params: {id: feed}
      expect(response).to be_ok
      expect(response.body).to_not include "failed"
    end

    it "should include import error warning" do
      feed = create(:feed, user: user, import_errors: 42)
      get :edit, params: {id: feed}
      expect(response).to be_ok
      expect(response.body).to include "The last 42 fetches of this feed failed."
    end
  end # describe "#edit"
end
