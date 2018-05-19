require "rails_helper"

describe GenerateNavService do
  let!(:user) { create(:user) }

  let!(:category1) { create(:category, user: user, name: "Category 1") }
  let!(:category2) { create(:category, user: user, name: "Category 2") }
  let!(:category3) { create(:category, user: user, name: "Category 3") }

  let!(:feed1) { create(:feed, user: user, category: category1, name: "Feed 1") }
  let!(:feed2) { create(:feed, user: user, category: category2, name: "Feed 2") }

  let!(:entry11) { create(:entry, user: user, feed: feed1) }
  let!(:entry12) { create(:entry, user: user, feed: feed1) }
  let!(:entry21) { create(:entry, user: user, feed: feed2, is_starred: true) }

  let(:nav) { described_class.call(user) }

  it "should generate nav" do
    expect(nav).to eq(
      :unread => {
        :name    => "All entries",
        :counter => 3,
      },

      :starred => {
        :name    => "Starred",
        :counter => 1,
      },

      :categories => [
        {
          :id      => category1.id,
          :name    => "Category 1",
          :counter => 2,
          :feeds   => [
            {
              :id      => feed1.id,
              :name    => "Feed 1",
              :counter => 2,
            },
          ],
        },

        {
          :id      => category2.id,
          :name    => "Category 2",
          :counter => 1,
          :feeds   => [
            {
              :id      => feed2.id,
              :name    => "Feed 2",
              :counter => 1,
            },
          ],
        },

        {
          :id      => category3.id,
          :name    => "Category 3",
          :counter => 0,
          :feeds   => [],
        },
      ],
    )
  end
end
