class Entry::Filter < Service
  attr_reader :scope, :options, :type, :category_id, :feed_id

  def initialize(scope, options = {})
    @scope       = scope
    @type        = options[:type].presence || "unread"
    @category_id = options[:category_id].presence
    @feed_id     = options[:feed_id].presence
  end

  def call
    @scope = @scope.where(is_read: false)   if type == "unread"
    @scope = @scope.where(is_starred: true) if type == "starred"

    if feed_id
      @scope = @scope.where(feed_id: feed_id)
    elsif category_id
      @scope = @scope.with_category_id(category_id)
    end

    @scope
  end

  def to_h
    [:category_id, :feed_id, :type].map { |option| [option, public_send(option)] }.to_h
  end
end
