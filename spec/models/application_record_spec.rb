require "rails_helper"

describe ApplicationRecord do
  describe "#to_s" do
    it "should return name if defined" do
      user = User.new(name: "Alice")
      expect(user.to_s).to eq "Alice"
    end

    it "should return default value" do
      animal = Temping.create(:dog)
      expect(animal.new.to_s).to start_with "#<Dog:"
    end
  end # describe "#to_s"
end
