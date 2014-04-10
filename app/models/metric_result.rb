class MetricResult
  attr_reader :metric, :value, :id, :metric_configuration, :error
  attr_accessor :descendant_results

  def initialize(metric_configuration, value, error=nil)
    @metric = metric_configuration.metric
    @metric_configuration = metric_configuration
    @value = value
    @error = error
  end

  def has_error?; !@error.nil?; end

  def aggreagated_value; raise NotImplmentedError; end

  def has_range?; !@metric_configuration.range.nil?; end
end