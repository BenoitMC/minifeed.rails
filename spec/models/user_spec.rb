require "rails_helper"

RSpec.describe User, type: :model do
  it { is_expected.to validate_presence_of :first_name }
  it { is_expected.to validate_presence_of :last_name }

  it "should not be registerable" do
    expect(User.devise_modules).to_not include :registerable
  end

  it "should have a valid factory" do
    expect(create :user).to be_valid
  end

  it "should return #name" do
    user = create(:user, first_name: "Jean", last_name: "DUPONT")
    expect(user.name).to eq "Jean DUPONT"
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
