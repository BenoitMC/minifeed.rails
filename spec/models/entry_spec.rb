require "rails_helper"

describe Entry, type: :model do
  it { is_expected.to belong_to :user }
  it { is_expected.to belong_to :feed }
  it { is_expected.to respond_to :category }

  it { is_expected.to validate_presence_of :user }
  it { is_expected.to validate_presence_of :external_id }
  it { is_expected.to validate_presence_of :name }
  it { is_expected.to validate_presence_of :published_at }

  it { is_expected.to allow_value(true).for(:is_read) }
  it { is_expected.to allow_value(false).for(:is_read) }
  it { is_expected.to_not allow_value(nil).for(:is_read) }

  it { is_expected.to allow_value(true).for(:is_starred) }
  it { is_expected.to allow_value(false).for(:is_starred) }
  it { is_expected.to_not allow_value(nil).for(:is_starred) }

  it { is_expected.to_not validate_presence_of :feed }
  it { is_expected.to_not validate_presence_of :body }
  it { is_expected.to_not validate_presence_of :url }

  describe "default values" do
    it "should set is_read to false" do
      expect(described_class.new.is_read).to be false
    end

    it "should set is_starred to false" do
      expect(described_class.new.is_starred).to be false
    end
  end # describe "default values"

  it "should have a valid factory" do
    expect(create(:entry)).to be_valid
  end

  describe "factories" do
    it "should return #unread entries" do
      read   = create(:entry, is_read: true)
      unread = create(:entry, is_read: false)

      expect(described_class.unread).to eq [unread]
    end

    it "should return #starred entries" do
      not_starred = create(:entry, is_starred: false)
      starred     = create(:entry, is_starred: true)

      expect(described_class.starred).to eq [starred]
    end

    it "#with_category_id should filter by category" do
      entry1 = create(:entry)
      entry2 = create(:entry)

      expect(described_class.with_category_id(entry1.feed.category.id)).to eq [entry1]
    end
  end # describe "factories"

  describe "search columns" do
    it "should normalize name" do
      subject.name = "<strong>crème brûlée</strong>"
      subject.send :set_search_columns
      expect(subject.name_for_search).to eq "creme brulee"
    end

    it "should generate keywords_for_search" do
      subject.name = "title"
      subject.body = "body"
      subject.author = "author"
      subject.send :set_search_columns
      expect(subject.keywords_for_search).to eq "title body author"
    end
  end # describe "search columns"
end
