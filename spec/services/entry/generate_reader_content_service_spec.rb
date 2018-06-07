require "rails_helper"

describe Entry::GenerateReaderContentService do
  it "should keep body only and remove unsafe tags" do
    raw_html = Rails.root.join("spec", "fixtures", "site.html").read
    expect(GetHTTP).to receive(:call).and_return(raw_html)

    html = described_class.call(Entry.new)
    expect(html).to eq %(<p>Hello world!</p>)
  end

  it "should catch GetHTTP errors" do
    expect(GetHTTP).to receive(:call) { raise GetHTTP::Error }
    html = described_class.call(Entry.new)
    expect(html).to eq "Error"
  end
end
