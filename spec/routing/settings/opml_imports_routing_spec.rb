require "rails_helper"

describe Settings::OpmlImportsController, type: :routing do
  describe "routing" do
    it "#new" do
      expect(get "/settings/opml-imports/new").to route_to("settings/opml_imports#new")
    end

    it "#create" do
      expect(post "/settings/opml-imports").to route_to("settings/opml_imports#create")
    end
  end
end
