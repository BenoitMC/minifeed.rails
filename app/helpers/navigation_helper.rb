module NavigationHelper
  def nav_categories
    policy_scope(Category).preload(:feeds)
  end

  def current_page_is_all_entries?
    controller_name == "entries" && action_name == "index" &&
      params[:category_id].blank? && params[:feed_id].blank? &&
      params[:type].to_s != "starred"
  end

  def current_page_is_starred?
    controller_name == "entries" && action_name == "index" &&
      params[:category_id].blank? && params[:feed_id].blank? &&
      params[:type].to_s == "starred"
  end

  def current_page_is_category?(category)
    controller_name == "entries" && action_name == "index" && category.id == params[:category_id]
  end

  def current_page_is_feed?(feed)
    controller_name == "entries" && action_name == "index" && feed.id == params[:feed_id]
  end
end
