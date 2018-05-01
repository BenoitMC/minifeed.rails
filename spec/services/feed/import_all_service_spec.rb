require "rails_helper"

describe Feed::ImportAllService do
  let(:feed1) { create(:feed, last_update_at: "2012-12-21 12:00:00") }
  let(:feed2) { create(:feed, last_update_at: "2012-12-21 10:00:00") }

  it "should call ImportService on each feed ordered by last_updated_at" do
    expect(Feed::ImportService).to receive(:call).with(feed2)
    expect(Feed::ImportService).to receive(:call).with(feed1)

    described_class.call
  end
end
