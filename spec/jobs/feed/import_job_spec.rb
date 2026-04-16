require "rails_helper"

describe Feed::ImportJob do
  let(:feed) { create(:feed) }

  it "should call import service" do
    expect(Feed::ImportService).to receive(:call).with(feed)
    Feed::ImportJob.perform_now(feed)
  end

  it "should not enqueue itself twice" do
    expect do
      described_class.perform_later(feed)
    end.to change(SolidQueue::Job, :count).by(1)

    expect do
      described_class.perform_later(feed)
    end.to_not change(SolidQueue::Job, :count)
  end
end
