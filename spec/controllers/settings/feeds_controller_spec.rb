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

  describe "#show" do
    it "should redirect to edit" do
      feed = create(:feed, user: user)
      get :show, params: {id: feed}
      expect(response).to redirect_to(action: :edit)
    end
  end # describe "#show"

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

  describe "#update" do
    it "should reset #last_update_at" do
      feed = create(:feed, user: user, last_update_at: 1.minute.ago)
      patch :update, params: {id: feed}
      expect(feed.reload.last_update_at).to eq nil
    end
  end # describe "#update"

  describe "#search" do
    let(:url) { "https://example.org" }

    it "should not search if url is blank" do
      expect(Feed::SearchService).to_not receive(:new)
      get :search, params: {url: ""}
      expect(response).to be_ok
      expect(response).to render_template(:search)
    end

    it "should display results if any" do
      dummy_result = Feed::SearchService::Result.new("https://example.org/", "Example domain")
      expect(Feed::SearchService).to receive(:call).with(url).and_return([dummy_result])
      get :search, params: {url: url}
      expect(assigns :results).to eq [dummy_result]
      expect(response).to be_ok
      expect(response).to render_template(:search)
    end

    it "should redirect and display error if no result" do
      expect(Feed::SearchService).to receive(:call).with(url).and_return([])
      get :search, params: {url: url}
      expect(flash.alert).to be_present
      expect(response).to redirect_to(action: :search)
    end

    it "should redirect and display error on service error" do
      expect(Feed::SearchService).to receive(:call).with(url).and_raise(Feed::SearchService::Error)
      get :search, params: {url: url}
      expect(flash.alert).to be_present
      expect(response).to redirect_to(action: :search)
    end
  end # describe "#search"
end
