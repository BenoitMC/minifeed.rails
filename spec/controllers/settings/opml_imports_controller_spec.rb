require "rails_helper"

describe Settings::OpmlImportsController do
  let(:user) { create(:user) }

  before { sign_in user }

  render_views

  describe "#new" do
    it "should be ok" do
      get :new
      expect(response).to be_ok
    end
  end # describe "#new"

  describe "#create" do
    let(:uploaded_file) {
      path = Rails.root.join("spec", "fixtures", "opml.inoreader.xml").to_s
      Rack::Test::UploadedFile.new(path, "text/xml")
    }

    it "should be ok" do
      expect(OpmlImportService).to receive(:call).with(user, /Example OPML/)

      post :create, params: {file: uploaded_file}

      expect(response).to redirect_to settings_root_path
      expect(flash[:success]).to be_present
      expect(flash[:danger]).to be_nil
    end

    it "should return error" do
      expect(OpmlImportService).to_not receive(:call)

      post :create

      expect(response).to redirect_to(action: :new)
      expect(flash[:danger]).to be_present
      expect(flash[:success]).to be_nil
    end
  end # describe "#create"
end
