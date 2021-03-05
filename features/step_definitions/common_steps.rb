Then("I see {string} in a new tab") do |text|
  # TODO : Fix
  # Temp disabled because it randomly fails on Travis CI

  # wait_for { windows.count }.to be > 1
  # switch_to_window windows.last
  # expect(page).to have_content(text)
end

Then("I see {string} before {string}") do |a, b|
  expect(source.index(a) < source.index(b)).to be true
end

Then("I reorder elements") do
  expect(page).to have_selector(".handle")

  # Temp disabled, not supported by Cuprite
  # all(".handle").last.drag_to all(".handle").first

  execute_script %(
    let el = find("tbody tr:last-child")
    el.parentNode.insertBefore(el, find("tbody tr:first-child"))
    find(".sortable").triggerEvent("sortupdate")
  )
end

Then("I am signed in") do
  expect(page).to have_selector "#user-nav"
end
