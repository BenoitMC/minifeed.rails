require "rails_helper"

describe Feed, type: :model do
  it { is_expected.to belong_to :user }
  it { is_expected.to belong_to :category }

  it { is_expected.to validate_presence_of :user }
  it { is_expected.to validate_presence_of :category }
  it { is_expected.to validate_presence_of :name }
  it { is_expected.to validate_presence_of :url }

  it { is_expected.to_not validate_presence_of :last_update_at }

  it "should validate that feed#user is category#user" do
    user     = create(:user)
    category = create(:category)

    feed = build(:feed, user: user, category: category)
    expect(feed).to_not be_valid
    expect(feed.errors).to have_key(:category)

    feed = build(:feed, user: category.user, category: category)
    expect(feed).to be_valid
  end

  it "should have a valid factory" do
    expect(create :feed).to be_valid
  end
end
