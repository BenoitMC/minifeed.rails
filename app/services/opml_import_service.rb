class OpmlImportService < Service
  initialize_with :user, :raw_xml

  def call
    xml.css("body > outline").each do |outline|
      if outline["xmlUrl"].present?
        import_feed_outline!(outline, no_category)
      else
        import_category_outline!(outline)
      end
    end

    true
  end

  private

  def no_category
    @no_category ||= Category.find_or_create_by!(user: user, name: "[no category]")
  end

  def import_feed_outline!(feed_outline, category)
    url  = feed_outline["xmlUrl"].presence
    name = feed_outline["title"].presence || feed_outline["text"].presence
    feed = Feed.find_by(user: user, url: url)

    return if url.blank? || name.blank? || feed.present?

    Feed.create!(
      :user     => user,
      :name     => name,
      :url      => url,
      :category => category,
    )
  end

  def import_category_outline!(category_outline)
    name = category_outline["title"].presence || category_outline["text"].presence

    if name.present?
      category = Category.find_or_create_by!(user: user, name: name)
    else
      category = no_category
    end

    category_outline.css("outline[xmlUrl]").each do |feed_outline|
      import_feed_outline!(feed_outline, category)
    end
  end

  def xml
    @xml ||= Nokogiri::XML(raw_xml.to_s)
  end
end
