class CompoundMetric < Metric
  attr_accessor :script
  def initialize(name, scope, script)
    super(true,name,scope)
    @script = script
  end
end