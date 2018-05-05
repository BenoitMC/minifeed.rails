class EntryPolicy < ApplicationPolicy
  def list?
    true
  end

  def read?
    true
  end

  def update?
    true
  end

  class Scope < Scope
    def resolve
      scope.where(user: current_user)
    end
  end
end
