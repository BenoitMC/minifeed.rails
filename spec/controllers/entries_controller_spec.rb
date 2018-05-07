require "rails_helper"

describe EntriesController do
  let(:user) { create(:user) }

  before { sign_in user }

  describe "#show" do
    it "should should set entry as read" do
      entry = create(:entry, user: user, is_read: false)
      get :show, params: {id: entry}
      expect(response).to be_ok
      expect(entry.reload.is_read?).to be true
    end
  end # describe "#show"

  describe "#update" do
    it "should should render show" do
      entry = create(:entry, user: user)
      patch :update, params: {id: entry}
      expect(response).to be_ok
      expect(response).to render_template(:show)
    end

    it "should render error" do
      entry = create(:entry, user: user)
      patch :update, params: {id: entry, entry: {is_starred: nil}}
      expect(response).to be_ok
      expect(response.body).to include "Error"
    end
  end # describe "#update"

  describe "#mark_as_read" do
    it "should mark all entries as read" do
      entry = create(:entry, user: user, is_read: false)
      post :mark_as_read
      expect(entry.reload.is_read?).to be true
    end

    it "should update only filtered entries" do
      entry1 = create(:entry, user: user, is_read: false)
      entry2 = create(:entry, user: user, is_read: false)
      post :mark_as_read, params: {category_id: entry1.feed.category.id}
      expect(entry1.reload.is_read?).to be true
      expect(entry2.reload.is_read?).to be false
    end

    it "should redirect to filtered index" do
      post :mark_as_read, params: {category_id: "123", type: "unread"}
      expect(response).to redirect_to(action: :index, category_id: "123", type: "unread")
    end
  end # describe "#mark_as_read"
end
