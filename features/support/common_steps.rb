# Clicks / Keyboard

When("I click on {string}") do |text|
  find(:minifeed_clickable, text).click
end

When("I click on first {string}") do |text|
  expect(page).to have_content(text)
  all(:minifeed_clickable, text).first.click
end

When("I click on last {string}") do |text|
  expect(page).to have_content(text)
  all(:minifeed_clickable, text).last.click
end

When("I click on {string} element") do |selector|
  find(selector).click
end

When("I click on first {string} element") do |selector|
  expect(page).to have_selector(selector)
  all(selector).first.click
end

When("I click on last {string} element") do |selector|
  expect(page).to have_selector(selector)
  all(selector).last.click
end

When("I press key {string}") do |key|
  find("body").send_keys(key.length == 1 ? key : key.to_sym)
end

# Routes

When("I go on the {string} page") do |route_name|
  path = main_app.public_send("#{route_name}_path")
  visit path
end

Then("I am on the {string} page") do |route_name|
  path = main_app.public_send("#{route_name}_path")
  wait_for { current_path }.to eq path
end

# Contents

Then("I see {string}") do |text|
  expect(page).to have_content(text)
end

Then("I do not see {string}") do |text|
  expect(page).to have_no_content(text)
end

Then("I see {string} element") do |selector|
  expect(page).to have_selector(selector)
end

Then("I do not see {string} element") do |selector|
  expect(page).to have_no_selector(selector)
end

Then("I see {int} times {string} element") do |count, selector|
  expect(page).to have_selector(selector, count:)
end

Then("I see {string} in modal") do |text|
  expect(find("#modal")).to have_content(text)
end

Then("I see {string} element in modal") do |selector|
  expect(find("#modal")).to have_selector(selector)
end

Then("I see {string} out of modal") do |text|
  expect(page).to have_no_selector("#modal")
  expect(page).to have_content(text)
end

Then("I see {string} element out of modal") do |selector|
  expect(page).to have_no_selector("#modal")
  expect(page).to have_selector(selector)
end

# Forms

When("I fill in {string} with {string}") do |id, value|
  fill_in id, with: value
end

When("I select {string}") do |value|
  select value
end

When("I select {string} from {string}") do |value, from|
  select value, from:
end

When(/^I select2 "([^"]*)" from "([^"]*)"$/) do |value, selector|
  select2(selector, value)
end

When("I fill in {string} with {string} file") do |id, file|
  expect(page).to have_selector(".form-group.file", visible: :all)

  execute_script %(
    $(".form-group.file").css("display", "block")
  )

  attach_file id, Rails.root.join("spec", "fixtures", file)
end

When("I search {string}") do |q|
  fill_in :q, with: q
  find(".search-submit").click
end

# Emails

Given("I clean my mailbox") do
  email_deliveries.clear
end

Then(/I have (\d+) emails?/) do |count|
  expect(email_deliveries.count).to eq count
end

# Factories

Given("an existing {string}") do |factory|
  instance_variable_set "@#{factory}", create(factory)
end

Given("I am a signed in {string}") do |factory|
  @user = create(factory) # rubocop:disable Rails/SaveBang
  sign_in @user
end
