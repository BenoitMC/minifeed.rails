require "rails_helper"

describe Settings::UsersController do
  before do
    sign_in create(:admin)
  end

  it { is_expected.to use_before_action(:ensure_user_is_admin!) }

  describe "#show" do
    it "should redirect to #edit" do
      user = create(:user)
      get :show, params: {id: user}
      expect(response).to redirect_to(action: :edit, id: user)
    end
  end # describe "#show"

  describe "#new" do
    it "should assign random password to user" do
      get :new
      expect(assigns(:user).password.length).to eq 8
    end
  end # describe "#new"

  describe "#update" do
    let!(:user) { create(:user) }

    it "should update password if not blank" do
      patch :update, params: {id: user, user: {password: "new_password"}}
      expect(response).to redirect_to(action: :index)
      expect(user.reload.valid_password?("new_password")).to be true
    end

    it "should not update password if is blank" do
      patch :update, params: {id: user, user: {password: " "}}
      expect(response).to redirect_to(action: :index)
      expect(user.reload.valid_password?("password")).to be true
    end
  end # describe "#update"

  describe "#destroy" do
    it "should destroy user" do
      user = create(:user)
      delete :destroy, params: {id: user}
      expect(response).to redirect_to(action: :index)
      expect { user.reload }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end # describe "#destroy"
end
