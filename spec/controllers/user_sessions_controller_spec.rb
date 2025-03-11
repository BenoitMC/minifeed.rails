require "rails_helper"

describe UserSessionsController do
  let!(:user) { create(:user) }

  describe "#new" do
    it "should be ok" do
      get :new
      expect(response).to be_ok
    end

    it "should redirect if already signed in" do
      sign_in user
      get :new
      expect(response).to redirect_to root_path
    end
  end # describe "#new"

  describe "#create" do
    it "should authenticate user" do
      expect_any_instance_of(described_class).to receive(:sign_in).with(user, remember_me: false).and_call_original
      post :create, params: {email: user.email, password: user.password}
      expect(response).to redirect_to root_path
      expect(assigns :current_user).to eq user
    end

    it "should authenticate and remember user" do
      expect_any_instance_of(described_class).to receive(:sign_in).with(user, remember_me: true).and_call_original
      post :create, params: {email: user.email, password: user.password, remember_me: "1"}
      expect(response).to redirect_to root_path
      expect(assigns :current_user).to eq user
    end

    it "should not authenticate user if invalid email" do
      post :create, params: {email: "invalid", password: user.password}
      expect(response).to be_unprocessable
      expect(response).to render_template :new
      expect(assigns :current_user).to be_nil
    end

    it "should not authenticate user if invalid password" do
      post :create, params: {email: user.email, password: "invalid"}
      expect(response).to be_unprocessable
      expect(response).to render_template :new
      expect(assigns :current_user).to be_nil
    end
  end # describe "#create"

  describe "#destroy" do
    it "should sign out user" do
      sign_in user
      delete :destroy
      expect(response).to redirect_to root_path
      expect(assigns :current_user).to be_nil
    end
  end # describe "#destroy"
end
