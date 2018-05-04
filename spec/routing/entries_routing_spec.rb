require "rails_helper"

describe EntriesController, type: :routing do
  describe "routing" do
    it "#index" do
      expect(get "/entries").to route_to("entries#index")
    end

    it "#show" do
      expect(get "/entries/123").to route_to("entries#show", id: "123")
    end
  end
end
