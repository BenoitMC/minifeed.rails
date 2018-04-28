require "rails_helper"

describe Rails do
  it "should return ::app_id" do
    expect(Rails.app_id).to eq "minifeed"
  end

  it "should return ::app_env_id" do
    expect(Rails.app_env_id).to eq "minifeed_test"
  end
end
