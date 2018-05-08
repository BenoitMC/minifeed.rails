When("I click on the {string} navigation item") do |id|
  find("#nav_#{id} a").click
end

Then("active navigation item is {string}") do |ids|
  ids = ids.split("+")

  ids.each do |id|
    expect(page).to have_selector("#nav_#{id}.active")
  end

  expect(page).to have_selector("#nav .active", count: ids.length)
end
