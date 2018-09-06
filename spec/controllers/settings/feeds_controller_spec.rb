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

  describe "#new" do
    it "form should not display other user categories" do
      create(:category, name: "Other user category")
      get :new
      expect(response).to be_ok
      expect(response.body).to_not include "Other user category"
    end
  end # describe "#new"

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

  describe "#search" do
    it "should not search on get" do
      expect(Feed::SearchService).to_not receive(:new)
      get :search
      expect(response).to be_ok
      expect(response).to render_template(:search)
    end

    it "should display results if any" do
      dummy_result = Feed::SearchService::Result.new("https://example.org/", "Example domain")
      expect_any_instance_of(Feed::SearchService).to receive(:call).and_return([dummy_result])
      post :search
      expect(assigns :results).to eq [dummy_result]
      expect(response).to be_ok
      expect(response).to render_template(:search)
    end

    it "should redirect and display error if no result" do
      expect_any_instance_of(Feed::SearchService).to receive(:call).and_return([])
      post :search
      expect(flash[:alert]).to be_present
      expect(response).to redirect_to(action: :search)
    end

    it "should redirect and display error on service error" do
      expect_any_instance_of(Feed::SearchService).to \
        receive(:call).and_raise(Feed::SearchService::Error)
      post :search
      expect(flash[:alert]).to be_present
      expect(response).to redirect_to(action: :search)
    end
  end # describe "#search"
end
