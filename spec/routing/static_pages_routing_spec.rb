require "rails_helper"

describe StaticPagesController, type: :routing do
  describe "routing" do
    it "#keyboard_shortcuts" do
      expect(get("/static-pages/keyboard-shortcuts")).to route_to("static_pages#keyboard_shortcuts")
    end
  end
end
