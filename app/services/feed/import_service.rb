class Feed::ImportService < Service
  initialize_with :feed

  def call
    feed_entries.each do |feed_entry|
      if feed.last_update_at && feed_entry.updated_at
        next if feed_entry.updated_at <= feed.last_update_at
      end

      create_or_update_entry!(feed_entry)
    end

    feed.update!(
      :last_update_at => feed_entries.map(&:updated_at).compact.max,
      :import_errors  => 0,
    )
  rescue Agilibox::GetHTTP::Error, Feedjira::NoParserAvailable
    feed.increment!(:import_errors) # rubocop:disable Rails/SkipsModelValidations
  end

  private

  def feed_entries
    @feed_entries ||= Feedjira::Feed.parse(raw_feed).entries
      .map { |feed_entry| FeedEntryAdapter.new(feed_entry) }
  end

  def raw_feed
    @raw_feed ||= Agilibox::GetHTTP.call(feed.url)
  end

  def create_or_update_entry!(feed_entry)
    return if feed_entry.external_id.blank?

    entry = Entry.find_or_initialize_by(
      :user        => feed.user,
      :feed        => feed,
      :external_id => feed_entry.external_id,
    )

    entry.attributes = {
      :name         => feed_entry.name,
      :body         => feed_entry.body,
      :author       => feed_entry.author,
      :url          => feed_entry.url,
      :published_at => feed_entry.published_at || entry.published_at || Time.zone.now,
    }

    entry.save!
  end
end
