require "rails_helper"

describe Entry::CreateFromUrlService do
  let(:url) { "https://example.org/some/page?some=param" }
  let(:raw_html) { file_fixture("site.html").read }
  let(:user) { create(:user) }
  let(:instance) { described_class.new(url, user:) }
  let(:invalid_url) { "ftp://invalid" }

  describe "in fake life" do
    before do
      allow(HttpClient).to receive(:request).with(:get, url).and_return(raw_html)
      travel_to Time.current.round
    end

    it "should create entry from site html" do
      expect do
        expect(instance.call).to eq true
      end.to change(Entry, :count).by(1)

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

    it "should not duplicate entry" do
      expect { instance.call }.to change(Entry, :count).by(1)
      expect { instance.call }.to_not change(Entry, :count)
    end

    it "should not create entry on invalid url" do
      expect do
        result = described_class.call(invalid_url, user:)
        expect(result).to eq false
      end.to_not change(Entry, :count)
    end

    it "should not create entry on nil url" do
      expect do
        result = described_class.call(nil, user:)
        expect(result).to eq false
      end.to_not change(Entry, :count)
    end

    it "should not crash if url is not html" do
      raw_html = file_fixture("binary.bin").read
      allow(HttpClient).to receive(:request).with(:get, url).and_return(raw_html)
      expect { instance.call }.to change(Entry, :count).by(1)
      entry = Entry.last_created
      expect(entry.name).to eq "https://example.org/some/page"
    end

    it "should not crash on http errors" do
      allow(HttpClient).to receive(:request).with(:get, url).and_raise(HTTP::Error)
      expect { instance.call }.to change(Entry, :count).by(1)
      entry = Entry.last_created
      expect(entry.name).to eq "https://example.org/some/page"
    end
  end # describe "in fake life"
end
