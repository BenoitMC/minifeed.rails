class ApplicationPolicy
  include Pundit

  attr_reader :current_user, :subject

  def initialize(current_user, subject)
    @current_user = current_user
    @subject      = subject
  end

  def self.inherited(klass)
    klass.define_accessor
  end

  def self.define_accessor
    # Dorsale::BillingMachine::InvoicePolicy -> :invoice
    object_type = to_s.split("::").last.chomp("Policy").underscore.to_sym

    # Avoid user/subject conflict
    object_type = :other_user if object_type == :user

    send(:define_method, object_type) { subject }
  end

  class Scope
    include Pundit

    attr_reader :current_user, :scope

    def initialize(current_user, scope)
      @current_user = current_user
      @scope        = scope
    end
  end
end
