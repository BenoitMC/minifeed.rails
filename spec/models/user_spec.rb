require "rails_helper"

describe User do
  it "should not be registerable" do
    expect(User.devise_modules).to_not include :registerable
  end

  it "should have a valid factory" do
    expect(create :user).to be_valid
  end

  it "should assign auth_token" do
    user = create(:user)
    expect(user.auth_token).to be_present
  end
end
