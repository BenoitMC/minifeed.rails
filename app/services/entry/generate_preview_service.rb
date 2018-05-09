class Entry::GeneratePreviewService < Service
  initialize_with :entry

  def call
    html = GetHTTP.call(entry.url)
    html = Nokogiri::HTML(html).css("body").to_s
    html = Loofah.fragment(html).scrub!(:prune).to_s
    html.strip
  rescue GetHTTP::Error
    "Error"
  end
end
