require "rails_helper"

describe Api::V1::EntriesController do
  let(:user) { create(:user) }

  before { sign_in user }

  describe "#index" do
    let!(:entry1) { create(:entry, user: user, is_read: false) }
    let!(:entry2) { create(:entry, user: user, is_read: false) }

    it "should should return entries" do
      get :index
      expect(response).to be_ok
      expect(json_response["entries"].length).to eq 2
    end

    it "should filter entries" do
      expect_any_instance_of(EntriesFilter).to receive(:call).and_call_original
      get :index, params: {category_id: entry1.feed.category.id}
      expect(response).to be_ok
      expect(json_response["entries"].length).to eq 1
      expect(json_response["entries"][0]["id"]).to eq entry1.id
    end
  end # describe "#index"

  describe "#update" do
    it "should should return entry" do
      entry = create(:entry, user: user)
      patch :update, params: {id: entry}
      expect(response).to be_ok
      expect(json_response).to have_key "entry"
      expect(json_response).to_not have_key "error"
    end

    it "should return error" do
      entry = create(:entry, user: user)
      patch :update, params: {id: entry, entry: {is_starred: nil}}
      expect(response.code).to eq "422"
      expect(json_response).to have_key "error"
      expect(json_response).to_not have_key "entry"
    end
  end # describe "#update"

  describe "#mark_all_as_read" do
    it "should mark all entries as read" do
      entry = create(:entry, user: user, is_read: false)
      post :mark_all_as_read
      expect(entry.reload.is_read?).to be true
    end

    it "should update only filtered entries" do
      entry1 = create(:entry, user: user, is_read: false)
      entry2 = create(:entry, user: user, is_read: false)
      post :mark_all_as_read, params: {category_id: entry1.feed.category.id}
      expect(entry1.reload.is_read?).to be true
      expect(entry2.reload.is_read?).to be false
    end

    it "should return filtered entries" do
      entry1 = create(:entry, user: user, is_read: false)
      entry2 = create(:entry, user: user, is_read: false)
      post :mark_all_as_read, params: {category_id: entry1.feed.category.id, type: "all"}
      expect(json_response["entries"].length).to eq 1
      expect(json_response["entries"][0]["id"]).to eq entry1.id
    end
  end # describe "#mark_all_as_read"
end