class Entry::Filter < Service
  attr_reader :scope, :options, :type, :category_id

  def initialize(scope, options = {})
    @scope       = scope
    @type        = options[:type].presence || "unread"
    @category_id = options[:category_id].presence
  end

  def call
    @scope = @scope.where(is_read: false)         if type == "unread"
    @scope = @scope.where(is_starred: true)       if type == "starred"
    @scope = @scope.with_category_id(category_id) if category_id

    @scope
  end
end
