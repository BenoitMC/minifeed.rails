class UserPolicy < ApplicationPolicy
  def update?
    current_user == other_user
  end
end
