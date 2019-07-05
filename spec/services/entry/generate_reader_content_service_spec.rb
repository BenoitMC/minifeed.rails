require "rails_helper"

describe Entry::GenerateReaderContentService do
  it "should keep body only and remove unsafe tags" do
    raw_html = Rails.root.join("spec", "fixtures", "site.html").read
    expect(HttpClient).to receive(:request).and_return(raw_html)

    html = described_class.call(Entry.new)
    expect(html).to eq %(<p>Hello world!</p>)
  end

  it "should catch HTTP errors" do
    expect(HttpClient).to receive(:request) { raise HTTP::Error }
    html = described_class.call(Entry.new)
    expect(html).to eq "Error"
  end

  it "should convert text to utf8" do
    iso88591_html = "<p>\xE9</p>".force_encoding("ISO-8859-1")
    expect(HttpClient).to receive(:request).and_return(iso88591_html)
    html = described_class.call(Entry.new)
    expect(html).to eq %(<p>\xC3\xA9</p>)
  end
end
