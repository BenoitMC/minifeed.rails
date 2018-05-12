class CategoryPolicy < ApplicationPolicy
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
    category.feeds.empty?
  end
end
