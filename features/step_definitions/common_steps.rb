Given(/^I am a signed in user$/) do
  @user = create(:user)
  visit main_app.root_path
  fill_in :user_email, with: @user.email
  fill_in :user_password, with: "password"
  find("[type=submit]").click
end
