class EntryAdapter < ApplicationAdapter
  attr_reader :original

  def initialize(original)
    @original = original.tap(&:sanitize!)
  end

  def external_id
    original.id.presence || original.url.presence
  end

  def name
    original.title.to_s.strip.presence || "[no title]"
  end

  def updated_at
    original.try(:updated).presence || original.published.presence
  end

  def published_at
    original.published.presence
  end

  def body
    original.content.presence || original.summary.presence
  end

  def_delegators :original, :author, :url
end
