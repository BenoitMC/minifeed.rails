require "rails_helper"

describe "Docker" do
  it "should have right ruby version" do
    docker_compose = YAML.safe_load(Rails.root.join("docker-compose.yml").read).deep_symbolize_keys
    image = docker_compose.dig(:services, :web, :image)
    expect(image).to eq "ruby:#{RUBY_VERSION}"
  end
end
