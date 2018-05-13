class FeedPolicy < ApplicationPolicy
  def list?
    true
  end

  def create?
    true
  end

  def update?
    true
  end

  def delete?
    true
  end
end
