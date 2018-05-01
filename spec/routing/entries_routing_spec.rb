require "rails_helper"

describe EntriesController, type: :routing do
  describe "routing" do
    it "#index" do
      expect(get "/entries").to route_to("entries#index")
    end
  end
end
