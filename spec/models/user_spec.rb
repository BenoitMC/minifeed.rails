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
end
