class CheckFramePermissionService < ApplicationService
  Error = Class.new(StandardError)

  attr_reader_initialize :url

  def call
    header = fetch_header.to_s.downcase
    header.blank? || header.include?("allowall")
  end

  private

  def fetch_header
    HttpClient.request(:get, url).headers[:x_frame_options]
  rescue HttpClient::Error => e
    raise Error, e.message
  end
end
