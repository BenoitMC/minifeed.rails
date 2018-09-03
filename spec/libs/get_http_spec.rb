require "rails_helper"

describe GetHTTP do
  describe "catch and reraise exceptions" do
    def self.it_should_catch_and_reraise(exception)
      it "should catch and reraise #{exception}" do
        arity = exception.instance_method(:initialize).arity
        args = ["_"] * [arity, 0].max
        expect(Net::HTTP).to receive(:get_response).and_raise(exception.new(*args))

        expect {
          described_class.call("http://example.org/")
        }.to raise_error(GetHTTP::Error)
      end
    end

    it_should_catch_and_reraise Errno::ECONNABORTED
    it_should_catch_and_reraise Errno::ECONNREFUSED
    it_should_catch_and_reraise Errno::ECONNRESET
    it_should_catch_and_reraise Errno::EHOSTDOWN
    it_should_catch_and_reraise Errno::EHOSTUNREACH
    it_should_catch_and_reraise Errno::ENETDOWN
    it_should_catch_and_reraise Errno::ENETRESET
    it_should_catch_and_reraise Errno::ENETUNREACH
    it_should_catch_and_reraise Net::HTTPBadResponse
    it_should_catch_and_reraise Net::HTTPError
    it_should_catch_and_reraise Net::HTTPFatalError
    it_should_catch_and_reraise Net::HTTPHeaderSyntaxError
    it_should_catch_and_reraise Net::HTTPRetriableError
    it_should_catch_and_reraise Net::HTTPServerException
    it_should_catch_and_reraise Net::OpenTimeout
    it_should_catch_and_reraise Net::ReadTimeout
    it_should_catch_and_reraise OpenSSL::SSL::SSLError
    it_should_catch_and_reraise SocketError
    it_should_catch_and_reraise Timeout::Error
    it_should_catch_and_reraise Zlib::Error
  end # describe "catch and reraise exceptions"

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
