require "rails_helper"

describe Settings::OpmlExportsController, type: :routing do
  describe "routing" do
    it "#create" do
      expect(post "/settings/opml-exports").to route_to("settings/opml_exports#create")
    end
  end
end
