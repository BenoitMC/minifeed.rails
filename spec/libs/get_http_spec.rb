require "rails_helper"

describe GetHTTP do
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

    it "should catch and reraise native exceptions" do
      expect {
        described_class.call("invalid")
      }.to raise_error(GetHTTP::Error)
    end

    it "should raise on invalid response codes" do
      expect {
        described_class.call("http://example.org/not-found")
      }.to raise_error(GetHTTP::Error)
    end
  end # describe "IRL"
end
