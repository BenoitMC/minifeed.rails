require "rails_helper"

describe Settings::OpmlExportsController do
  let(:user) { create(:user) }

  before { sign_in user }

  render_views

  describe "#create" do
    it "should be ok" do
      expect(OpmlExportService).to receive(:call).with(user).and_call_original

      post :create

      expect(response).to be_ok
      expect(response.content_type).to eq "application/octet-stream"
      expect(response.body).to include "<?xml"
    end
  end # describe "#create"
end
