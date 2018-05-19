require "rails_helper"

describe EntrySerializer do
  let(:user) { create(:user) }

  let(:category) { create(:category, user: user, name: "My category") }
  let(:feed) { create(:feed, user: user, category: category, name: "My feed") }
  let(:entry) { create(:entry, user: user, feed: feed) }

  let(:json) { described_class.call(entry) }

  it "should generate entry" do
    expect(json).to have_key "author"
    expect(json).to have_key "body"
    expect(json).to have_key "category_name"
    expect(json).to have_key "feed_name"
    expect(json).to have_key "id"
    expect(json).to have_key "is_read"
    expect(json).to have_key "is_starred"
    expect(json).to have_key "name"
    expect(json).to have_key "published_at_human"
    expect(json).to have_key "url"

    expect(json["category_name"]).to eq "My category"
    expect(json["feed_name"]).to eq "My feed"
    expect(json["published_at_human"]).to eq "less than a minute"
  end
end
