class Feed::ImportService < Service
  initialize_with :feed

  def call
    feed_entries_dates = []

    feed_entries.each do |feed_entry|
      updated = feed_entry.try(:updated) || feed_entry.published
      feed_entries_dates << updated
      next if feed.last_update_at && updated && updated <= feed.last_update_at
      create_or_update_entry!(feed_entry)
    end

    feed.update!(last_update_at: feed_entries_dates.compact.max)
  rescue GetHTTP::Error
    feed.increment!(:import_errors) # rubocop:disable Rails/SkipsModelValidations
  end

  private

  def feed_entries
    @feed_entries ||= Feedjira::Feed.parse(raw_feed).sanitize_entries!
  end

  def raw_feed
    @raw_feed ||= GetHTTP.call(feed.url)
  end

  def create_or_update_entry!(feed_entry)
    external_id = feed_entry.id

    return if external_id.blank?

    entry = Entry.find_or_initialize_by(
      :user        => feed.user,
      :feed        => feed,
      :external_id => external_id,
    )

    name         = feed_entry.title.presence || "[no title]"
    published_at = feed_entry.published || entry.published_at || Time.zone.now
    body         = feed_entry.content.presence || feed_entry.summary

    entry.attributes = {
      :name         => name,
      :body         => body,
      :author       => feed_entry.author,
      :url          => feed_entry.url,
      :published_at => published_at,
    }

    entry.save!
  end
end
