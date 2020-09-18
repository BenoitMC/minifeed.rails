class EntryAdapter < ApplicationAdapter
  CLASSES_AND_IDS_SCRUBBER = Loofah::Scrubber.new do |node|
    if node.attributes["class"].present?
      node.attributes["class"].value = node.attributes["class"].value.to_s
        .split(" ")
        .map { |e| "x-#{e}" }
        .join(" ")
    end

    if node.attributes["id"].present?
      node.attributes["id"].value = "x-" + node.attributes["id"].value.to_s
    end
  end

  private_constant :CLASSES_AND_IDS_SCRUBBER

  attr_reader :original

  def initialize(original)
    super()
    @original = original.tap(&:sanitize!)
  end

  def external_id
    original.id.presence || original.url.presence
  end

  def name
    name = original.title.to_s.strip.presence || "[no title]"
    Nokogiri::HTML(name).text
  end

  def updated_at
    original.try(:updated).presence || original.published.presence
  end

  def published_at
    original.published.presence
  end

  def body
    Loofah.fragment(raw_body).scrub!(CLASSES_AND_IDS_SCRUBBER).to_s
  end

  def_delegators :original, :author, :url

  private

  def raw_body
    original.content.presence || original.summary.presence
  end
end
