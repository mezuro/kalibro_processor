class NativeMetric < Metric
  attr_accessor :languages
  def initialize(name, code, scope, languages)
    super(false,name,code,scope)
    @languages = languages
  end
end