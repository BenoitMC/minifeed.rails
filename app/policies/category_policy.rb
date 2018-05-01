class CategoryPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.where(user: current_user)
    end
  end
end
