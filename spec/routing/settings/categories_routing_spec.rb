require "rails_helper"

describe Settings::CategoriesController, type: :routing do
  describe "routing" do
    it "#index" do
      expect(get "/settings/categories").to route_to("settings/categories#index")
    end

    it "#new" do
      expect(get "/settings/categories/new").to route_to("settings/categories#new")
    end

    it "#create" do
      expect(post "/settings/categories").to route_to("settings/categories#create")
    end

    it "#show" do
      expect(get "/settings/categories/0").to route_to("settings/categories#show", id: "0")
    end

    it "#edit" do
      expect(get "/settings/categories/0/edit").to route_to("settings/categories#edit", id: "0")
    end

    it "#update" do
      expect(patch "/settings/categories/0").to route_to("settings/categories#update", id: "0")
    end

    it "#destroy" do
      expect(delete "/settings/categories/0").to route_to("settings/categories#destroy", id: "0")
    end

    it "#reorder via get" do
      expect(get "/settings/categories/reorder").to route_to("settings/categories#reorder")
    end

    it "#reorder via post" do
      expect(post "/settings/categories/reorder").to route_to("settings/categories#reorder")
    end
  end
end
