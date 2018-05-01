require "rails_helper"

describe OpmlImportService do
  let(:user) { create(:user) }

  let(:no_category_label) { "[no category]" }

  def import!
    raw_xml = Rails.root.join("spec", "fixtures", "opml.inoreader.xml").read
    described_class.call(user, raw_xml)
  end

  describe "cateogies" do
    it "should create unexisting categories" do
      expect { import! }.to change(Category, :count).by(2)

      category1, category2 = Category.reorder(:id)

      expect(category1.name).to eq no_category_label
      expect(category1.user).to eq user

      expect(category2.name).to eq "Category 1 Name"
      expect(category2.user).to eq user
    end

    it "should reuse existing categories" do
      create(:category, user: user, name: no_category_label)
      create(:category, user: user, name: "Category 1 Name")

      expect { import! }.to_not change(Category, :count)
    end

    it "should not reuse other users existing categories" do
      create(:category, name: no_category_label)
      create(:category, name: "Category 1 Name")

      expect { import! }.to change(Category, :count).by(2)
    end
  end # describe "cateogies"

  describe "feeds" do
    it "should create feeds" do
      expect { import! }.to change(Feed, :count).by(2)

      feed1, feed2 = Feed.reorder(:id)

      expect(feed1.name).to          eq "Feed 0 Name"
      expect(feed1.user).to          eq user
      expect(feed1.category.name).to eq no_category_label
      expect(feed1.url).to           eq "http://site0.example.org/feed.xml"

      expect(feed2.name).to          eq "Feed 1 Name"
      expect(feed2.user).to          eq user
      expect(feed2.category.name).to eq "Category 1 Name"
      expect(feed2.url).to           eq "https://site1.example.org/feed.xml"
    end

    it "should not duplicate and not update existing feeds" do
      feed1 = create(:feed, user: user, url: "http://site0.example.org/feed.xml", name: "F1")
      feed2 = create(:feed, user: user, url: "https://site1.example.org/feed.xml", name: "F2")

      expect { import! }.to_not change(Feed, :count)
      expect(feed1.reload.name).to eq "F1"
      expect(feed2.reload.name).to eq "F2"
    end

    it "should duplicate other users existing feeds" do
      feed1 = create(:feed, url: "http://site0.example.org/feed.xml")
      feed2 = create(:feed, url: "https://site1.example.org/feed.xml")

      expect { import! }.to change(Feed, :count).by(2)
    end
  end # describe "feeds"

  it "should return true" do
    expect(import!).to eq true
  end

  describe "on invalid input" do
    it "should not raise if input is not xml " do
      expect {
        described_class.call(user, "i'm not a valid xml")
      }.to_not raise_error
    end

    it "should on invalid opml " do
      raw_xml = Rails.root.join("spec", "fixtures", "opml.invalid.xml").read

      expect {
        described_class.call(user, raw_xml)
      }.to_not raise_error
    end
  end # describe "on invalid input"
end
