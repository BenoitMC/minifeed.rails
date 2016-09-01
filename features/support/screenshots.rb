After do |scenario|
  if scenario.failed?
    page.save_screenshot(scenario.name.parameterize +  ".png")
  end
end
