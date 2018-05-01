class Feed::ImportService < Service
  initialize_with :feed

  def call
    feed_entries.each do |feed_entry|
      updated = feed_entry.updated || feed_entry.published
      next if feed.last_update_at && updated && updated < feed.last_update_at
      create_or_update_entry!(feed_entry)
    end

    feed.update!(last_update_at: Time.zone.now)
  end

  private

  def feed_entries
    @feed_entries ||= Feedjira::Feed.parse(raw_feed).sanitize_entries!
  end

  def raw_feed
    @raw_feed ||= URI.parse(feed.url).open.read
  end

  def create_or_update_entry!(feed_entry)
    entry = Entry.find_or_initialize_by(
      :user        => feed.user,
      :feed        => feed,
      :external_id => feed_entry.id,
    )

    name = feed_entry.title.presence || "[no title]"

    entry.attributes = {
      :name        => name,
      :body        => feed_entry.summary,
      :url         => feed_entry.url,
    }

    entry.save!
  end
end
