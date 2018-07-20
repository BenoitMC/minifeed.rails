require "rails_helper"

describe GetHTTP do
  it "should catch and reraise native exceptions" do
    expect(Net::HTTP).to receive(:get_response).and_raise(SocketError)

    expect {
      described_class.call("http://example.org/")
    }.to raise_error(GetHTTP::Error)
  end

  it "should allow HTTP URI" do
    instance = described_class.new("http://example.org/")
    expect(instance.uri).to be_a URI::HTTP
  end

  it "should allow HTTPS URI" do
    instance = described_class.new("https://example.org/")
    expect(instance.uri).to be_a URI::HTTPS
  end

  it "should allow other URIs" do
    instance = described_class.new("ftp://example.org/")

    expect {
      instance.uri
    }.to raise_error(GetHTTP::Error, "invalid URI type : URI::FTP")
  end

  describe "IRL" do
    it "should work" do
      body = described_class.call("http://example.org/")
      expect(body).to include "Example Domain"
    end

    it "should follow redirects" do
      service = described_class.new("https://www.github.com/")
      body = service.call
      expect(body).to include "Sign in"
      expect(service.url).to eq "https://github.com/"
    end

    it "should raise on invalid response codes" do
      expect {
        described_class.call("http://example.org/not-found")
      }.to raise_error(GetHTTP::Error)
    end
  end # describe "IRL"
end
