After do |scenario|
  page.save_screenshot(scenario.name.parameterize + ".png") if scenario.failed?
end
