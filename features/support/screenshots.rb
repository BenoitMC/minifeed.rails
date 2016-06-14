After do |scenario|
  if scenario.failed?
    page.save_screenshot(scenario.title.parameterize +  ".png")
  end
end
