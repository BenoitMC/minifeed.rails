module AuthControllerConcern
  extend ActiveSupport::Concern

  included do
    helper_method :current_user
  end

  private

  def user_session_storage
    cookies.encrypted
  end

  def sign_in(user, remember_me: false)
    expires = remember_me ? 1.year.from_now : nil
    user_session_storage[:user_auth] = { value: user.auth_token, expires: }
    @current_user = user
  end

  def current_user
    @current_user ||= user_session_storage[:user_auth].presence&.then { User.find_by!(auth_token: it) }
  rescue ActiveRecord::RecordNotFound
    sign_out
  end

  def sign_out
    user_session_storage[:user_auth] = nil
    @current_user = nil
  end

  def authenticate_user!
    redirect_to new_user_session_path if current_user.nil?
  end

  def ensure_user_is_admin!
    return if current_user&.is_admin?

    flash.alert = t("errors.not_admin")
    redirect_to root_path
  end
end
