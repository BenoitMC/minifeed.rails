require "rails_helper"

describe Entry::GenerateCountersService do
  let!(:user) { create(:user) }

  let!(:category1) { create(:category, user:) }
  let!(:category2) { create(:category, user:) }

  let!(:feed1) { create(:feed, user:, category: category1) }
  let!(:feed2) { create(:feed, user:, category: category2) }

  let!(:entry11) { create(:entry, user:, feed: feed1) }
  let!(:entry12) { create(:entry, user:, feed: feed1) }
  let!(:entry21) { create(:entry, user:, feed: feed2, is_starred: true) }

  let(:counters) { described_class.call(user) }

  it "should generate a counter for each category/feed" do
    expect(counters[category1.id]).to eq 2
    expect(counters[category2.id]).to eq 1
    expect(counters[feed1.id]).to eq 2
    expect(counters[feed2.id]).to eq 1
    expect(counters[:unread]).to eq 3
    expect(counters[:starred]).to eq 1
  end

  it "should not return read entries" do
    entry11.update!(is_read: true)
    entry12.update!(is_read: true)
    entry21.update!(is_read: true)

    expect(counters[category1.id]).to eq 0
    expect(counters[category2.id]).to eq 0
    expect(counters[feed1.id]).to eq 0
    expect(counters[feed2.id]).to eq 0
    expect(counters[:unread]).to eq 0
  end

  it "should count user data only" do
    entry = create(:entry)

    expect(counters).to_not have_key(entry.feed.id)
    expect(counters).to_not have_key(entry.feed.category.id)
  end
end
