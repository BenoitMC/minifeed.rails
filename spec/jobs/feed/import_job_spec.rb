require "rails_helper"

describe Feed::ImportJob do
  it "should call import service" do
    feed = build(:feed)
    expect(Feed::ImportService).to receive(:call).with(feed)
    Feed::ImportJob.perform_now(feed)
  end
end
