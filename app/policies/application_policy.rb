class ApplicationPolicy
  class Scope
    include Pundit

    attr_reader :current_user, :scope

    def initialize(current_user, scope)
      @current_user = current_user
      @scope        = scope
    end

    def resolve
      scope.where(user: current_user)
    end
  end
end
