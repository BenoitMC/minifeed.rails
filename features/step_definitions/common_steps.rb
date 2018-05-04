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
