require "rails_helper"

describe Settings::UsersController do
  let(:current_user) { create(:admin) }
  before { sign_in current_user }

  it { is_expected.to use_before_action(:ensure_user_is_admin!) }

  render_views

  describe "#index" do
    it "should be ok" do
      get :index
      expect(response).to be_ok
      expect(assigns :users).to eq [current_user]
    end
  end # describe "#index"

  describe "#new" do
    it "should assign random password to user" do
      get :new
      expect(assigns(:user).password.length).to eq 8
    end
  end # describe "#new"

  describe "#create" do
    it "be ok" do
      valid_params = {
        :name     => "Alice",
        :email    => "alice@example.org",
        :password => "my_password",
      }

      expect {
        post :create, params: {user: valid_params}
      }.to change(User, :count).by(1)

      expect(response).to redirect_to(action: :index)
    end

    it "should assign password if blank" do
      post :create, params: {user: {password: ""}}
      expect(response).to be_unprocessable
      expect(assigns(:user).password.length).to eq 8
    end

    it "should not override password if present" do
      post :create, params: {user: {password: "hello"}}
      expect(response).to be_unprocessable
      expect(assigns(:user).password).to eq "hello"
    end
  end # describe "#create"

  describe "#show" do
    it "should redirect to #edit" do
      user = create(:user)
      get :show, params: {id: user}
      expect(response).to redirect_to(action: :edit, id: user)
    end
  end # describe "#show"

  describe "#edit" do
    it "should be ok" do
      user = create(:user)
      get :edit, params: {id: user}
      expect(response).to be_ok
    end
  end # describe "#edit"

  describe "#update" do
    let!(:user) { create(:user) }

    it "should update user" do
      patch :update, params: {id: user, user: {name: "Bob"}}
      expect(response).to redirect_to(action: :index)
      expect(user.reload.name).to eq "Bob"
    end

    it "should render errors" do
      patch :update, params: {id: user, user: {name: ""}}
      expect(response).to be_unprocessable
      expect(response).to render_template(:edit)
    end

    it "should update password if not blank" do
      patch :update, params: {id: user, user: {password: "new_password"}}
      expect(response).to redirect_to(action: :index)
      expect(user.reload.authenticate("new_password")).to be user
    end

    it "should not update password if is blank" do
      patch :update, params: {id: user, user: {password: " "}}
      expect(response).to redirect_to(action: :index)
      expect(user.reload.authenticate("password")).to be user
    end

    it "should sign_in if user is me" do
      expect_any_instance_of(described_class).to receive(:sign_in).with(current_user)
      patch :update, params: {id: current_user, user: {password: "new_password"}}
    end

    it "should not sign_in if user is not me" do
      expect_any_instance_of(described_class).to_not receive(:sign_in)
      patch :update, params: {id: user, user: {password: "new_password"}}
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
