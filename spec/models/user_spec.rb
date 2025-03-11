require "rails_helper"

describe User do
  describe "associations" do
    it { is_expected.to have_many(:categories).dependent(:destroy) }
    it { is_expected.to have_many(:feeds).dependent(:destroy) }
  end # describe "associations"

  describe "validations" do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:email) }
    it { is_expected.to validate_presence_of(:password) }
    it { is_expected.to validate_length_of(:password).is_at_least(8) }
  end # describe "validations"

  describe "factories" do
    it "should have a valid user factory" do
      user = build(:user)
      expect(user).to be_valid
      expect(user.is_admin).to be false
    end

    it "should have a valid admin factory" do
      user = build(:admin)
      expect(user).to be_valid
      expect(user.is_admin).to be true
    end
  end # describe "factories"

  describe "#auth_token" do
    it "should assign auth_token on create" do
      user = create(:user)
      expect(user.auth_token).to be_present
    end

    it "should reset auth token if password changed" do
      user = create(:user)
      old_token = user.auth_token
      user.update!(password: "new password")
      expect(user.auth_token).to_not eq old_token
    end

    it "should not reset auth token if password didn't changed" do
      user = create(:user)
      old_token = user.auth_token
      user.update!(name: "new name")
      expect(user.auth_token).to eq old_token
    end
  end # describe "#auth_token"
end
