class ApplicationService
  extend AttrExtras.mixin

  def self.call(...)
    new(...).call
  end
end
