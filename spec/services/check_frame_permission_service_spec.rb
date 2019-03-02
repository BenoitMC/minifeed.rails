require "rails_helper"

describe CheckFramePermissionService do
  describe "#call" do
    def self.it_should_return(value, with:)
      it "should return #{value} for #{with}" do
        instance = described_class.new(nil)
        expect(instance).to receive(:fetch_header).and_return(with)
        expect(instance.call).to eq value
      end
    end

    it_should_return true, with: nil
    it_should_return true, with: ""
    it_should_return true, with: "ALLOWALL"
    it_should_return true, with: "allowall"
    it_should_return false, with: "DENY"
    it_should_return false, with: "SAMEORIGIN"
    it_should_return false, with: "ALLOW-FROM https://example.com/"
  end # describe "#call"

  it "should catch and reraise http exception" do
    instance = described_class.new("invalid")
    expect {
      instance.call
    }.to raise_error(described_class::Error)
  end

  describe "in real life" do
    it "should fetch header" do
      instance = described_class.new("https://github.com/")
      expect(instance.send :fetch_header).to eq "deny"
    end
  end # describe "in real life"
end
