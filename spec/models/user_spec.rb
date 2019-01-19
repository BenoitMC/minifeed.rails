require "rails_helper"

describe User do
  it { is_expected.to have_many(:categories).dependent(:destroy) }
  it { is_expected.to have_many(:feeds).dependent(:destroy) }

  it "should not be registerable" do
    expect(User.devise_modules).to_not include :registerable
  end

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

  it "should assign auth_token" do
    user = create(:user)
    expect(user.auth_token).to be_present
  end
end
