require "rails_helper"

describe AuthControllerConcern, type: :controller do
  controller(ActionController::Base) do
    include AuthControllerConcern

    def index; end
  end

  def action(&)
    controller.define_singleton_method(:index, &)
    get :index
  end

  let!(:user) { create(:user) }

  describe "#sign_in" do
    it "should set the user_auth cookie" do
      action do
        sign_in(User.sole)
        head :ok
      end
      expect(response).to be_ok
      expect(user_session_storage[:user_auth]).to eq user.auth_token
    end
  end # describe "#sign_in"

  describe "#current_user" do
    it "should set user from cookie" do
      user_session_storage[:user_auth] = user.auth_token
      action do
        current_user
        head :ok
      end
      expect(response).to be_ok
      expect(assigns(:current_user)).to eq user
    end

    it "should return nil if no cookie" do
      action do
        current_user
        head :ok
      end
      expect(response).to be_ok
      expect(assigns(:current_user)).to eq nil
    end

    it "should return nil and sign out if invalid user id" do
      user_session_storage[:user_auth] = "invalid"
      action do
        current_user
        head :ok
      end
      expect(response).to be_ok
      expect(assigns(:current_user)).to eq nil
      expect(user_session_storage[:user_auth]).to eq nil
    end
  end # describe "#current_user"

  describe "#sign_out" do
    it "should clear the user_auth cookie" do
      user_session_storage[:user_auth] = user.auth_token
      action do
        current_user
        sign_out
        head :ok
      end
      expect(assigns(:current_user)).to eq nil
      expect(user_session_storage[:user_auth]).to eq nil
    end
  end # describe "#sign_out"

  describe "#authenticate_user!" do
    controller(ActionController::Base) do
      include AuthControllerConcern

      before_action :authenticate_user!

      def index
        head :ok
      end
    end

    it "should do nothing if authenticated" do
      sign_in create(:user)
      get :index
      expect(response).to be_ok
    end

    it "should redirect to sign_in page if not authenticared" do
      get :index
      expect(response).to redirect_to "/user_session/new"
    end
  end # describe "#authenticate_user!"

  describe "#ensure_user_is_admin!" do
    controller(ActionController::Base) do
      include AuthControllerConcern

      before_action :ensure_user_is_admin!

      def index
        head :ok
      end
    end

    it "should be ok as admin" do
      sign_in create(:admin)
      get :index
      expect(response).to be_ok
    end

    it "should be redirect as user" do
      sign_in create(:user)
      get :index
      expect(flash.alert).to be_present
      expect(response).to redirect_to "/"
    end
  end # describe "#ensure_user_is_admin!"
end
