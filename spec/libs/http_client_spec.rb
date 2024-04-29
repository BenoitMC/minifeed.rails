require "rails_helper"

describe HttpClient do
  describe "invalid response in real life" do
    it "should be ok" do
      expect {
        HttpClient.request(:get, "https://example.org/")
      }.to_not raise_error
    end

    it "should raise error on invalid responses" do
      expect {
        HttpClient.request(:get, "https://example.org/favicon.ico")
      }.to raise_error(HttpClient::ResponseNotOkError, "Invalid response: 404 Not Found")
    end

    it "should allow redirects" do
      expect {
        response = HttpClient.request(:get, "https://www.github.com/")
        expect(response.uri.to_s).to eq "https://github.com/"
      }.to_not raise_error
    end
  end # describe "invalid response in real life"
end
