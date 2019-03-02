require "rails_helper"

describe EntriesController, type: :routing do
  describe "routing" do
    it "#index" do
      expect(get "/entries").to route_to("entries#index")
    end

    it "#show" do
      expect(get "/entries/123").to route_to("entries#show", id: "123")
    end

    it "#reader" do
      expect(get "/entries/123/reader").to route_to("entries#reader", id: "123")
    end

    it "#iframe" do
      expect(get "/entries/123/iframe").to route_to("entries#iframe", id: "123")
    end

    it "#update" do
      expect(patch "/entries/123").to route_to("entries#update", id: "123")
    end

    it "#mark_all_as_read" do
      expect(post "/entries/mark-all-as-read").to route_to("entries#mark_all_as_read")
    end
  end
end
