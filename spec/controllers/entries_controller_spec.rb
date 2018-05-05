require "rails_helper"

describe EntriesController do
  let(:user) { create(:user) }

  before { sign_in user }

  describe "#show" do
    it "should should set entry as read" do
      entry = create(:entry, user: user, is_read: false)
      get :show, params: {id: entry}
      expect(response).to be_ok
      expect(entry.reload).to be_is_read
    end
  end

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
  end
end
