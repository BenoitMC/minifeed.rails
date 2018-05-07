require "rails_helper"

describe User do
  it "should not be registerable" do
    expect(User.devise_modules).to_not include :registerable
  end

  it "should have a valid factory" do
    expect(create :user).to be_valid
  end

  describe "#id" do
    it "should be present on build" do
      expect(User.new.id).to be_present
    end

    it "should not change on saves" do
      user = build(:user)
      id   = user.id
      expect(id).to be_present

      user.update!(email: "user2@example.org")
      expect(user.id).to eq id

      user.update!(email: "user3@example.org")
      expect(user.id).to eq id
    end
  end # describe "#id"
end
