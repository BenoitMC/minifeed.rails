class EntriesFilter < ApplicationService
  attr_reader :scope, :options, :type, :category_id, :feed_id, :q, :q_src

  def initialize(scope, options = {})
    super()

    @scope       = scope
    @type        = options[:type].presence || "unread"
    @category_id = options[:category_id].presence
    @feed_id     = options[:feed_id].presence
    @q           = options[:q].presence
    @q_src       = options[:q_src].presence
  end

  def call
    @scope = @scope.where(is_read: false)   if type == "unread"
    @scope = @scope.where(is_starred: true) if type == "starred"

    if feed_id
      @scope = @scope.where(feed_id:)
    elsif category_id
      @scope = @scope.with_category_id(category_id)
    end

    @scope = @scope.search(q, q_src) if q.present?

    @scope
  end

  def to_h
    [:category_id, :feed_id, :q, :q_src, :type].index_with { |option| public_send(option) }
  end
end
