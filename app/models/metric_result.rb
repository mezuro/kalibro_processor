class MetricResult
  attr_reader :metric, :value, :id, :metric_configuration, :error
  attr_accessor :descendant_results

  def initialize(metric_configuration, value, error=nil)
    @metric = metric_configuration.metric
    @metric_configuration = metric_configuration
    @value = value
    @error = error
    @descendant_results = DescriptiveStatistics::Stats.new(Array.new)
    def @descendant_results.average
      self.mean
    end
  end

  def has_error?; !@error.nil?; end

  def aggregated_value
    if (@value.nan? && !@descendant_results.empty?)
      @descendant_results.send( @metric_configuration.aggregation_form.to_s.downcase )
    else
      @value
    end
  end

  def has_range?; !@metric_configuration.range.nil?; end

  def has_grade?; has_range? && !@metric_configuration.range.reading.nil?; end
end
