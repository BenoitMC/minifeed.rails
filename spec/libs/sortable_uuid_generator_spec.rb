require "rails_helper"

describe SortableUuidGenerator do
  it "should generate a valid uuid" do
    uuid = described_class.call
    expect(uuid).to match described_class::REGEX_WITH_DASHES
  end

  it "should still work in 100 years" do
    travel_to 100.years.from_now
    uuid = described_class.call
    expect(uuid).to match described_class::REGEX_WITH_DASHES
  end

  it "should be incremental" do
    uuids = []

    100.times { uuids << described_class.call }

    travel_to 1.day.from_now
    uuids << described_class.call
    travel_to 1.month.from_now
    uuids << described_class.call
    travel_to 1.year.from_now
    uuids << described_class.call
    travel_to 10.years.from_now
    uuids << described_class.call
    travel_to 100.years.from_now
    uuids << described_class.call

    expect(uuids).to eq uuids.sort
  end
end
