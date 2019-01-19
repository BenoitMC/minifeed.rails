require "rails_helper"

describe Settings::UsersController, type: :routing do
  describe "routing" do
    it "#index" do
      expect(get "/settings/users").to route_to("settings/users#index")
    end

    it "#new" do
      expect(get "/settings/users/new").to route_to("settings/users#new")
    end

    it "#create" do
      expect(post "/settings/users").to route_to("settings/users#create")
    end

    it "#show" do
      expect(get "/settings/users/0").to route_to("settings/users#show", id: "0")
    end

    it "#edit" do
      expect(get "/settings/users/0/edit").to route_to("settings/users#edit", id: "0")
    end

    it "#update" do
      expect(patch "/settings/users/0").to route_to("settings/users#update", id: "0")
    end

    it "#destroy" do
      expect(delete "/settings/users/0").to route_to("settings/users#destroy", id: "0")
    end
  end
end
