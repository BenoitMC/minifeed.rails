require "rails_helper"

describe Category, type: :model do
  it { is_expected.to belong_to :user }
  it { is_expected.to have_many(:feeds).dependent(:nullify) }

  it { is_expected.to validate_presence_of :user }
  it { is_expected.to validate_presence_of :name }

  it "should have a valid factory" do
    expect(create :category).to be_valid
  end
end
