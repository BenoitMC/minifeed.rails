require "rails_helper"

describe Entry::Filter do
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
      entry = create(:entry)
      list  = filter(category_id: entry.feed.category.id)
      expect(list).to eq [entry]
    end
  end # describe ":category_id option"
end
