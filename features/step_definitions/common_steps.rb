Given(/^I am a signed in user$/) do
  @user = create(:user)
  sign_in @user
end

Then("I see {string}") do |text|
  expect(page).to have_content(text)
end

Then("I do not see {string}") do |text|
  expect(page).to have_no_content(text)
end

Then("I see {string} element") do |selector|
  expect(page).to have_selector(selector)
end

Then("I see {int} times {string} element") do |count, selector|
  expect(page).to have_selector(selector, count: count)
end

Then("I do not see {string} element") do |selector|
  expect(page).to have_no_selector(selector)
end

When("I click on {string}") do |text|
  click_on text
end

Then("I see {string} in modal") do |text|
  expect(find("#modal")).to have_content(text)
end

When("I click on {string} element") do |selector|
  find(selector).click
end

Then("I see {string} in a new tab") do |text|
  expect(windows.count > 1).to be true
  switch_to_window windows.last
  expect(page).to have_content(text)
end

When("I press key {string}") do |key|
  find("body").send_keys(key.length == 1 ? key : key.to_sym)
end

When("I fill in {string} with {string}") do |id, value|
  fill_in id, with: value
end

Then("I see {string} before {string}") do |a, b|
  expect(source.index(a) < source.index(b)).to be true
end

Then("I reorder elements") do
  expect(page).to have_selector(".handle")

  evaluate_script %( $("tbody").append($("tbody tr").eq(0).detach()) )
  evaluate_script %( $(".sortable").trigger("sortupdate") )
end

When("I select {string}") do |value|
  select value
end
