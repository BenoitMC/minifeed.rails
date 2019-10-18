class Entry::GenerateCountersService < ApplicationService
  initialize_with :user

  def call
    counters = Hash.new(0)

    counters[:unread] = entries_scope.unread.count

    counters[:starred] = entries_scope.starred.count

    counters.merge! categories_scope
      .left_joins(feeds: :entries)
      .where(entries: {is_read: false})
      .group(:id).count

    counters.merge! feeds_scope
      .left_joins(:entries)
      .where(entries: {is_read: false})
      .group(:id).count

    counters
  end

  private

  def categories_scope
    Pundit.policy_scope!(user, Category)
  end

  def feeds_scope
    Pundit.policy_scope!(user, Feed)
  end

  def entries_scope
    Pundit.policy_scope!(user, Entry)
  end
end
