require "rails_helper"

describe ApplicationController do
  describe "not found errors" do
    render_views

    controller do
      def index
        raise ActiveRecord::RecordNotFound
      end
    end

    it "should rescue error" do
      sign_in create(:user)

      expect { get :index }.to_not raise_error

      expect(response.status).to eq 404
      expect(response).to render_template "errors/not_found"
      expect(response.body).to include "Error"
    end
  end # describe "not found errors"

  describe "csrf errors" do
    render_views

    controller do
      def index
        raise ActionController::InvalidAuthenticityToken
      end
    end

    it "should rescue error" do
      sign_in create(:user)

      expect { get :index }.to_not raise_error

      expect(response).to redirect_to root_path
      expect(flash.alert).to include "Session has expired."
    end
  end # describe "csrf errors"

  describe "format errors" do
    render_views

    controller do
      def index
        raise ActionController::UnknownFormat
      end
    end

    it "should rescue ActionController::UnknownFormat" do
      sign_in create(:user)

      expect { get :index }.to_not raise_error

      expect(response.status).to eq 406
    end
  end # describe "format errors"
end
