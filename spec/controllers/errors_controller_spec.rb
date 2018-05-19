require "rails_helper"

describe ErrorsController do
  render_views

  describe "#not_found" do
    it "should be not found" do
      get :not_found, params: {path: "z"}
      # expect(response).to be_not_found
      expect(response.code).to eq "404"
    end
  end
end
