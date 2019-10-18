require "rails_helper"

describe Entry::CreateFromUrlService do
  let(:url) { "https://example.org/" }
  let(:raw_html) { Rails.root.join("spec", "fixtures", "site.html").read }
  let(:user) { create(:user) }
  let(:instance) { described_class.new(url, user: user) }

  describe "in fake life" do
    before do
      allow(HttpClient).to receive(:request).with(:get, url).and_return(raw_html)
      Timecop.freeze Time.current.round
    end

    it "should create entry from site html" do
      expect { instance.call }.to change(Entry, :count).by(1)
      entry = Entry.last_created
      expect(entry.user).to eq user
      expect(entry.feed).to eq nil
      expect(entry.external_id).to eq url
      expect(entry.name).to eq "Example Domain"
      expect(entry.body).to eq "Example Domain Description !"
      expect(entry.url).to eq url
      expect(entry.author).to eq "Alice"
      expect(entry.published_at).to eq Time.current
      expect(entry.is_read).to eq true
      expect(entry.is_starred).to eq true
    end

    it "should find data in alternative tags" do
      allow(instance).to receive(:meta_description).and_return(nil)
      allow(instance).to receive(:meta_author).and_return(nil)

      expect { instance.call }.to change(Entry, :count).by(1)
      entry = Entry.last_created
      expect(entry.body).to eq "OG Example Domain Description !"
      expect(entry.author).to eq "OG Site Name"
    end

    it "should not duplicate entry" do
      expect { instance.call }.to change(Entry, :count).by(1)
      expect { instance.call }.to_not change(Entry, :count)
    end
  end # describe "in fake life"
end
