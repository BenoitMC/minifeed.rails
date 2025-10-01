require "rails_helper"

describe ApplicationHelper do
  include FontAwesomeHelper

  describe "#boolean_icon" do
    it "should return nil if nil" do
      expect(boolean_icon(nil)).to eq nil
    end

    it "should return check icon if true" do
      expect(boolean_icon(true)).to eq \
        %(<span class="fa-check fas icon" style="color: green"></span>)
    end

    it "should return times icon if false" do
      expect(boolean_icon(false)).to eq \
        %(<span class="fa-times fas icon" style="color: red"></span>)
    end

    it "should raise an error on invalid value" do
      expect { boolean_icon 123 }.to raise_error(ArgumentError)
    end
  end # describe "#boolean_icon"
end
