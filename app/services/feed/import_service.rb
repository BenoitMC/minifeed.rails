class Feed::ImportService < ApplicationService
  initialize_with :feed

  def call
    remote_entries.each do |remote_entry|
      create_or_update_entry!(remote_entry)
    end

    feed.import_errors = 0
  rescue HttpClient::Error, Feedjira::NoParserAvailable
    feed.import_errors += 1
  ensure
    feed.last_import_at = Time.zone.now
    feed.save!
  end

  private

  def remote_entries
    @remote_entries ||= Feedjira.parse(raw_feed).entries
      .map { |remote_entry| EntryAdapter.new(remote_entry) }
  end

  def raw_feed
    @raw_feed ||= HttpClient.request(:get, feed.url).to_s
  end

  def create_or_update_entry!(remote_entry)
    return if remote_entry.external_id.blank?
    return if excluded_by_blacklist?(remote_entry)
    return if excluded_by_whitelist?(remote_entry)

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

  def excluded_by_blacklist?(remote_entry)
    return false if feed.normalized_blacklist.empty?
    normalized_name = remote_entry.name.parameterize
    feed.normalized_blacklist.any? { |e| normalized_name.include?(e) }
  end

  def excluded_by_whitelist?(remote_entry)
    return false if feed.normalized_whitelist.empty?
    normalized_name = remote_entry.name.parameterize
    feed.normalized_whitelist.none? { |e| normalized_name.include?(e) }
  end
end
