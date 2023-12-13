require "rails_helper"

describe EntriesFilter do
  def filter(options = {})
    described_class.call(Entry.all, options)
  end

  let!(:read)      { create(:entry, is_read: true)     }
  let!(:unread)    { create(:entry, is_read: false)    }
  let!(:starred)   { create(:entry, is_starred: true)  }
  let!(:unstarred) { create(:entry, is_starred: false) }

  describe ":type option" do
    it "default type should be unread" do
      expect(described_class.new(nil).type).to eq "unread"
    end

    it "should filter by unread type" do
      entries = filter(type: "unread")
      expect(entries).to include unread
      expect(entries).to_not include read
    end

    it "should filter by starred type" do
      entries = filter(type: "starred")
      expect(entries).to include starred
      expect(entries).to_not include unstarred
    end

    it "should filter by all type" do
      entries = filter(type: "all")
      expect(entries).to include read
      expect(entries).to include unread
      expect(entries).to include starred
      expect(entries).to include unstarred
    end
  end # describe ":type option"

  describe ":category_id option" do
    it "should filter by category" do
      entry1 = create(:entry)
      entry2 = create(:entry)
      list   = filter(category_id: entry1.feed.category.id)
      expect(list).to eq [entry1]
    end
  end # describe ":category_id option"

  describe ":feed_id option" do
    it "should filter by feed" do
      entry1 = create(:entry)
      entry2 = create(:entry)
      list   = filter(feed_id: entry1.feed.id)
      expect(list).to eq [entry1]
    end
  end # describe ":category_id option"

  describe ":q option" do
    it "should filter by search" do
      read.update!(name: "ruby")
      unread.update!(name: "rails")

      entries = filter(type: "all", q: "ruby", q_src: "name")
      expect(entries).to include read
      expect(entries).to_not include unread
    end
  end # describe ":q option"

  it "#to_h should return params" do
    filter = described_class.new(nil, category_id: "123", feed_id: "456", q: "ruby", q_src: "name")
    expect(filter.to_h).to eq(
      :category_id => "123",
      :feed_id     => "456",
      :q           => "ruby",
      :q_src       => "name",
      :type        => "unread",
    )
  end
end
