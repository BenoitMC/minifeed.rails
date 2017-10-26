Given(/^I am a signed in user$/) do
  @user = create(:user)
  sign_in @user
end
