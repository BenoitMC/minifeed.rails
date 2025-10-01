require "rails_helper"

describe ErrorsController do
  render_views

  describe "#not_found" do
    it "should be not found" do
      get :not_found, params: { path: "z" }
      expect(response).to be_not_found
      expect(response).to render_template "errors/not_found"
    end

    it "should not crash with unknown format" do
      get :not_found, params: { path: "z", format: :xml }
      expect(response).to be_not_found
      expect(response).to render_template "errors/not_found"
    end
  end
end
