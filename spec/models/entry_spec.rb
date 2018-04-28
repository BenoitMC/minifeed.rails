require "rails_helper"

describe Entry, type: :model do
  it { is_expected.to belong_to :user }
  it { is_expected.to belong_to :feed }

  it { is_expected.to validate_presence_of :user }
  it { is_expected.to validate_presence_of :feed }
  it { is_expected.to validate_presence_of :external_id }
  it { is_expected.to validate_presence_of :name }
  it { is_expected.to validate_inclusion_of(:is_read).in_array([true, false]) }
  it { is_expected.to validate_inclusion_of(:is_starred).in_array([true, false]) }

  it { is_expected.to_not validate_presence_of :body }
  it { is_expected.to_not validate_presence_of :url }

  describe "default values" do
    it "should set is_read to false" do
      expect(described_class.new.is_read).to be false
    end

    it "should set is_starred to false" do
      expect(described_class.new.is_starred).to be false
    end
  end # describe "default values"

  it "should have a valid factory" do
    expect(create :entry).to be_valid
  end
end
