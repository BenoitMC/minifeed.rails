class Ability
  include CanCan::Ability

  def initialize(user)
    return if user.nil?
  end
end
