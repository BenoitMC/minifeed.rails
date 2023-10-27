require "rails_helper"

describe EntriesController do
  let(:user) { create(:user) }
  before { sign_in user }

  let!(:entry) {
    create(:entry, user:, is_read: false)
  }

  describe "#new" do
    render_views

    it "should be ok" do
      get :new
      expect(response).to be_ok
    end
  end # describe "#new"

  describe "#create" do
    let(:url) { "https://example.org/" }

    it "should create entry" do
      expect(Entry::CreateFromUrlService).to receive(:call).and_return(true)
      get :create, params: {url:}
      expect(response).to be_redirect
      expect(flash.notice).to be_present
    end

    it "should handle invalid urls" do
      expect(Entry::CreateFromUrlService).to receive(:call).and_return(false)
      get :create, params: {url:}
      expect(response).to be_redirect
      expect(flash.alert).to be_present
    end
  end # describe "#create"

  describe "#show" do
    it "should should set entry as read" do
      get :show, params: {id: entry}
      expect(response).to be_ok
      expect(entry.reload.is_read?).to be true
    end
  end # describe "#show"

  describe "iframe" do
    it "should redirect to url if frames are allowed" do
      expect(CheckFramePermissionService).to receive(:call).with(entry.url).and_return(true)
      get :iframe, params: {id: entry}
      expect(response).to redirect_to entry.url
    end

    it "should render errors message if frames are not allowed" do
      expect(CheckFramePermissionService).to receive(:call).with(entry.url).and_return(false)
      get :iframe, params: {id: entry}
      expect(response).to be_ok
      expect(assigns :html).to include "does not allow"
      expect(response).to render_template(:reader, layout: false)
    end

    it "should render errors message on http error" do
      expect(CheckFramePermissionService).to \
        receive(:call).and_raise(CheckFramePermissionService::Error)

      get :iframe, params: {id: entry}
      expect(response).to be_ok
      expect(assigns :html).to include "seems to be unavailable"
      expect(response).to render_template(:reader, layout: false)
    end
  end # describe "iframe"

  describe "#update" do
    it "should should render update" do
      patch :update, params: {id: entry}
      expect(response).to be_ok
      expect(response).to render_template(:update)
    end

    it "should render error" do
      patch :update, params: {id: entry, entry: {is_starred: nil}}
      expect(response).to be_ok
      expect(response).to render_template(:update_error)
    end
  end # describe "#update"

  describe "#mark_all_as_read" do
    it "should mark all entries as read" do
      post :mark_all_as_read
      expect(entry.reload.is_read?).to be true
    end

    it "should update only filtered entries" do
      entry1 = entry
      entry2 = create(:entry, user:, is_read: false)
      post :mark_all_as_read, params: {category_id: entry1.feed.category.id}
      expect(entry1.reload.is_read?).to be true
      expect(entry2.reload.is_read?).to be false
    end

    it "should redirect to filtered index" do
      post :mark_all_as_read, params: {category_id: "123", type: "unread"}
      expect(response).to redirect_to(action: :index, category_id: "123", type: "unread")
    end
  end # describe "#mark_all_as_read"
end
