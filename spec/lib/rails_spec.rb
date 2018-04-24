require "rails_helper"

describe Rails do
  it "should return ::app_id" do
    expect(Rails.app_id).to eq "mom"
  end

  it "should return ::app_env_id" do
    expect(Rails.app_env_id).to eq "mom_test"
  end
end
