require "rails_helper"

describe Entry::GenerateReaderContentService do
  it "should keep body only and remove unsafe tags" do
    raw_html = Rails.root.join("spec", "fixtures", "site.html").read
    expect(Agilibox::GetHTTP).to receive(:call).and_return(raw_html)

    html = described_class.call(Entry.new)
    expect(html).to eq %(<p>Hello world!</p>)
  end

  it "should catch GetHTTP errors" do
    expect(Agilibox::GetHTTP).to receive(:call) { raise Agilibox::GetHTTP::Error }
    html = described_class.call(Entry.new)
    expect(html).to eq "Error"
  end

  it "should convert text to utf8" do
    iso88591_html = "<p>\xE9</p>".force_encoding("ISO-8859-1")
    expect(Agilibox::GetHTTP).to receive(:call).and_return(iso88591_html)
    html = described_class.call(Entry.new)
    expect(html).to eq %(<p>\xC3\xA9</p>)
  end
end
