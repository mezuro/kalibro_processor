class NativeMetric < Metric
  attr_accessor :languages
  def initialize(name, scope, languages)
    super(false,name,scope)
    @languages = languages
  end
end