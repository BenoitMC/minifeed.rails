require "rails_helper"

describe HttpClient do
  fake_response = Data.define(:code)

  describe "invalid response in real life" do
    it "should be ok" do
      response = fake_response.new(code: 200)
      expect_any_instance_of(HTTP::Client).to receive(:request).and_return(response)
      result = HttpClient.request(:get, "https://example.org/")
      expect(result).to eq response
    end

    it "should raise error on invalid responses" do
      response = fake_response.new(code: 404)
      expect_any_instance_of(HTTP::Client).to receive(:request).and_return(response)
      expect do
        HttpClient.request(:get, "https://example.org/")
      end.to raise_error(HttpClient::ResponseNotOkError, "Invalid response: 404")
    end
  end # describe "invalid response in real life"
end
