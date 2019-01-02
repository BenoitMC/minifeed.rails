class Feed::ImportService < Service
  initialize_with :feed

  def call
    remote_entries.each do |remote_entry|
      if feed.last_update_at && remote_entry.updated_at
        next if remote_entry.updated_at <= feed.last_update_at
      end

      create_or_update_entry!(remote_entry)
    end

    feed.update!(
      :last_update_at => remote_entries.map(&:updated_at).compact.max,
      :import_errors  => 0,
    )
  rescue Agilibox::GetHTTP::Error, Feedjira::NoParserAvailable
    feed.increment!(:import_errors) # rubocop:disable Rails/SkipsModelValidations
  end

  private

  def remote_entries
    @remote_entries ||= Feedjira::Feed.parse(raw_feed).entries
      .map { |remote_entry| FeedEntryAdapter.new(remote_entry) }
  end

  def raw_feed
    @raw_feed ||= Agilibox::GetHTTP.call(feed.url)
  end

  def create_or_update_entry!(remote_entry)
    return if remote_entry.external_id.blank?

    local_entry = Entry.find_or_initialize_by(
      :user        => feed.user,
      :feed        => feed,
      :external_id => remote_entry.external_id,
    )

    local_entry.attributes = {
      :name         => remote_entry.name,
      :body         => remote_entry.body,
      :author       => remote_entry.author,
      :url          => remote_entry.url,
      :published_at => remote_entry.published_at || local_entry.published_at || Time.zone.now,
    }

    local_entry.save!
  end
end
