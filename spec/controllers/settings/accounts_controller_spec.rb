require "rails_helper"

describe Settings::AccountsController do
  let(:user) { create(:user) }
  before { sign_in user }
  render_views

  describe "#edit" do
    it "should be ok" do
      get :edit
      expect(response).to be_ok
    end
  end # describe "#edit"

  describe "#update" do
    it "should update user" do
      patch :update, params: {user: {email: "new@example.org", password: "new_password"}}
      expect(response).to redirect_to settings_root_path
      user.reload
      expect(user.email).to eq "new@example.org"
      expect(user.valid_password?("new_password")).to be true
    end

    it "should ignore password if blank" do
      patch :update, params: {user: {email: "new@example.org", password: ""}}
      expect(response).to redirect_to settings_root_path
      expect(user.reload.valid_password?("password")).to be true
    end

    it "should render edit on invalid attribtues" do
      patch :update, params: {user: {email: ""}}
      expect(response).to render_template(:edit)
      expect(user.reload.email).to be_present
    end
  end # describe "#update"
end
