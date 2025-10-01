require "rails_helper"

describe Feed::ImportOutdatedJob do
  it "should enqueue import job if feed is outdated" do
    create(:feed, last_import_at: 1.day.ago)
    expect do
      described_class.perform_now
    end.to change(SolidQueue::Job, :count).by(1)
  end

  it "should enqueue import job if feed was neved imported" do
    create(:feed, last_import_at: nil)
    expect do
      described_class.perform_now
    end.to change(SolidQueue::Job, :count).by(1)
  end

  it "should not enqueue import job if feed was imported recently" do
    create(:feed, last_import_at: 1.minute.ago)
    expect do
      described_class.perform_now
    end.to_not change(SolidQueue::Job, :count)
  end

  it "should not enqueue itself twice" do
    expect do
      described_class.perform_later
    end.to change(SolidQueue::Job, :count).by(1)

    expect do
      described_class.perform_later
    end.to_not change(SolidQueue::Job, :count)
  end

  it "should not enqueue import job if already enqueued" do
    create(:feed, last_import_at: 1.day.ago)
    described_class.perform_now
    expect do
      described_class.perform_now
    end.to_not change(SolidQueue::Job, :count)
  end
end
