require "rails_helper"

describe ApplicationController do
  describe "not_found" do
    render_views

    controller do
      def index
        raise ActiveRecord::RecordNotFound
      end
    end

    it "should rescue ActiveRecord::RecordNotFound" do
      sign_in create(:user)

      expect { get :index }.to_not raise_error

      expect(response.status).to eq 404
      expect(response).to render_template "errors/not_found"
      expect(response.body).to include "Erreur"
    end
  end # describe "render_not_found"
end
