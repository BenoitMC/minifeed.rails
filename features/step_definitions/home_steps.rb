When(/^I go to the home page$/) do
  visit main_app.root_path
end

Then(/^I see the home page$/) do
  expect(page).to have_content "Hello world !"
end
