module CucumberSignIn
  include Warden::Test::Helpers

  def sign_out
    logout
  end

  def sign_in(user)
    sign_out
    visit(new_user_session_path)
    fill_in "user_email",    with: user.email
    fill_in "user_password", with: user.password
    find("[type=submit]").click
  end
end

World(CucumberSignIn)
