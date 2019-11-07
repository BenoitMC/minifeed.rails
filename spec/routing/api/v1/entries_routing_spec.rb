require "rails_helper"

describe Api::V1::EntriesController, type: :routing do
  describe "routing" do
    it "#index" do
      expect(get "/api/v1/entries").to \
        route_to("api/v1/entries#index")
    end

    it "#create" do
      expect(post "/api/v1/entries").to \
        route_to("api/v1/entries#create")
    end

    it "#update" do
      expect(patch "/api/v1/entries/123").to \
        route_to("api/v1/entries#update", id: "123")
    end

    it "#mark_all_as_read" do
      expect(post "/api/v1/entries/mark-all-as-read").to \
        route_to("api/v1/entries#mark_all_as_read")
    end
  end
end
