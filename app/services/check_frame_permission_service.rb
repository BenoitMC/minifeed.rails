class CheckFramePermissionService < Service
  Error = Class.new(StandardError)

  initialize_with :url

  def call
    header = fetch_header.to_s.downcase
    header.blank? || header.include?("allowall")
  end

  private

  def fetch_header
    Agilibox::GetHTTP.new(url).response["x-frame-options"]
  rescue Agilibox::GetHTTP::Error => e
    raise Error, e.message
  end
end
