require "rails_helper"

describe Settings::FeedsController, type: :routing do
  describe "routing" do
    it "#index" do
      expect(get "/settings/feeds").to route_to("settings/feeds#index")
    end

    it "#new" do
      expect(get "/settings/feeds/new").to route_to("settings/feeds#new")
    end

    it "#create" do
      expect(post "/settings/feeds").to route_to("settings/feeds#create")
    end

    it "#show" do
      expect(get "/settings/feeds/0").to route_to("settings/feeds#show", id: "0")
    end

    it "#edit" do
      expect(get "/settings/feeds/0/edit").to route_to("settings/feeds#edit", id: "0")
    end

    it "#update" do
      expect(patch "/settings/feeds/0").to route_to("settings/feeds#update", id: "0")
    end

    it "#destroy" do
      expect(delete "/settings/feeds/0").to route_to("settings/feeds#destroy", id: "0")
    end

    it "#search via get" do
      expect(get "/settings/feeds/search").to route_to("settings/feeds#search")
    end

    it "#search via post" do
      expect(post "/settings/feeds/search").to route_to("settings/feeds#search")
    end
  end
end
