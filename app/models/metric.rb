class Metric
  attr_accessor :compound, :name, :code, :scope, :description

  def initialize(compound, name, code, scope)
    @compound = compound
    @name = name
    @code = code
    @scope = scope
    @description = ""
  end
end