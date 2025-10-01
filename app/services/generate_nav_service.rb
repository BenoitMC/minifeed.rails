class GenerateNavService < ApplicationService
  attr_reader_initialize :user

  def call
    nav = {}

    nav[:unread] = {
      name: I18n.t("nav.unread"),
      counter: counters[:unread],
    }

    nav[:starred] = {
      name: I18n.t("nav.starred"),
      counter: counters[:starred],
    }

    nav[:categories] = []

    categories_scope.each do |category|
      nav[:categories] << {
        id: category.id,
        name: category.name,
        counter: counters[category.id],
        feeds: [],
      }

      category.feeds.each do |feed|
        nav[:categories].last[:feeds] << {
          id: feed.id,
          name: feed.name,
          counter: counters[feed.id],
        }
      end
    end

    nav
  end

  private

  def counters
    @counters ||= Entry::GenerateCountersService.call(user)
  end

  def categories_scope
    Pundit.policy_scope!(user, Category).preload(:feeds)
  end
end
