class Metric
  attr_accessor :compound, :name, :scope, :description

  def initialize(compound, name, scope)
    @compound = compound
    @name = name
    @scope = scope
    @description = ""
  end
end