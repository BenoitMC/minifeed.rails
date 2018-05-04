When("I click on the {string} navigation item") do |id|
  find("#nav_#{id} a").click
end

Then("active navigation item is {string}") do |id|
  expect(page).to have_selector("#nav_#{id}.active")
  expect(page).to have_selector("#nav .active", count: 1)
end
