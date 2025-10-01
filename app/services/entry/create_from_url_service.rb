class Entry::CreateFromUrlService < ApplicationService
  attr_reader :url, :user

  def initialize(url, user:)
    super()

    @url = url
    @user = user
  end

  def call
    return false if invalid_url?

    entry = Entry.find_or_initialize_by(user:, feed: nil, external_id: url)

    entry.attributes = {
      name: sanitize(page.best_title) || sanitized_url,
      body: sanitize(page.best_description),
      author: sanitize(page.best_author),
      url: url,
      published_at: Time.current,
      is_read: true,
      is_starred: true,
    }

    entry.save!
  end

  private

  def invalid_url?
    !URI.parse(url.to_s).is_a?(URI::HTTP)
  end

  def sanitized_url
    url.split("?").first
  end

  def page
    @page ||= MetaInspector.new(url, document: raw_html)
  end

  def raw_html
    @raw_html ||= HttpClient.request(:get, url).to_s
  rescue HttpClient::Error
    ""
  end

  def sanitize(text)
    text.to_s.strip.presence
  end
end
