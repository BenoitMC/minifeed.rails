require "rails_helper"

describe "Docker" do
  it "should have right ruby version" do
    dockerfile_ruby_version = Rails.root.join("Dockerfile").read.scan(/ruby:(.{5})/).first.first
    expect(dockerfile_ruby_version).to eq RUBY_VERSION
  end
end
