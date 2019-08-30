require "rails_helper"

describe Feed::ImportOutdatedService do
  let!(:feed3) { create(:feed, last_import_at: "2012-12-21 12:00:00") }
  let!(:feed1) { create(:feed, last_import_at: nil) }
  let!(:feed2) { create(:feed, last_import_at: "2012-12-21 10:00:00") }

  let(:service) { described_class.new }

  it "#feeds should return feeds ordered by last_import_at" do
    expect(service.feeds).to eq [feed1, feed2, feed3]
  end

  it "#feeds should not return recently imported feeds" do
    recent = create(:feed, last_import_at: Time.zone.now)
    expect(service.feeds).to_not include recent
  end

  it "should call ImportService on each feed and ignore exception" do
    expect(Feed::ImportService).to receive(:call).with(feed1)
    expect(Feed::ImportService).to receive(:call).with(feed2)
    expect(Feed::ImportService).to receive(:call).with(feed3) { raise "err" }

    expect { described_class.call }.to_not raise_error
  end

  it "should not enqueue feeds if queue is not empty" do
    expect_any_instance_of(ThreadPool).to receive(:empty?).and_return(false)
    expect_any_instance_of(described_class).to_not receive(:post)

    described_class.call
  end
end
