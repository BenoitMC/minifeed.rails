module CapybaraSignIn
  def sign_in(user)
    visit(new_user_session_path)
    fill_in "user_email",    with: user.email
    fill_in "user_password", with: user.password
    find("[type=submit]").click
  end
end

World(CapybaraSignIn)
