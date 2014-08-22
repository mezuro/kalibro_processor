class CompoundMetric < Metric
  attr_accessor :script
  def initialize(name, code, scope, script)
    super(true,name,code,scope)
    @script = script
  end
end