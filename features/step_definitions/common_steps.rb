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
