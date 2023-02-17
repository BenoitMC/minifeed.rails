Capybara.add_selector(:minifeed_clickable) do
  xpath do |locator, **options|
    %i[link button label]
      .map { |selector| expression_for(selector, locator, **options) }
      .reduce(:union)
  end
end
