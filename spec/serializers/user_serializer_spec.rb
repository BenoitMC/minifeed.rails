require "rails_helper"

describe UserSerializer do
  let(:user) { create(:user) }
  let(:json) { described_class.call(user) }

  it "should all infos if user is current_user" do
    json = described_class.call(user, current_user: user)
    expect(json.keys).to contain_exactly("id", "email", "auth_token")
  end

  it "should return only public infos if user is NOT current_user" do
    other_user = create(:user)
    json = described_class.call(user, current_user: other_user)
    expect(json.keys).to contain_exactly("id")
  end
end
