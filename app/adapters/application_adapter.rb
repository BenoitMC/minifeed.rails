class ApplicationAdapter
  extend Forwardable

  attr_reader :original

  def initialize(original)
    @original = original
  end
end
