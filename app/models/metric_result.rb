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

  def aggregated_value; raise NotImplementedError; end

  def has_range?; !@metric_configuration.range.nil?; end

  def has_grade?; has_range? && !@metric_configuration.range.reading.nil?; end
end