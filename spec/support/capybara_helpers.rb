RSpec.configure do
  def capybara_sign_in(user)
    visit(new_user_session_path)
    fill_in "email", with: user.email
    fill_in "password", with: user.password
    first("[type=submit]").click
    expect(page).to have_selector ".toast-success"
  end
end
