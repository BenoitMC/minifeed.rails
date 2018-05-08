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
end
