class MetricResult
  attr_reader :metric, :value, :id, :metric_configuration, :error
  attr_accessor :descendant_results

  def initialize(metric_configuration, value, error=nil)
    @metric = metric_configuration.metric
    @metric_configuration = metric_configuration
    @value = value
    @error = error
  end

  def descendant_results=(value)
    @descendant_results = DescriptiveStatistics::Stats.new(value)
    def @descendant_results.average
      self.mean
    end
  end

  def aggregated_value
    if (self.value.nil? && !self.descendant_results.empty?)
      self.descendant_results.send( self.metric_configuration.aggregation_form.to_s.downcase )
    else
      self.value
    end
  end

  def has_range?; !@metric_configuration.range.nil?; end

  def has_grade?; has_range? && !@metric_configuration.range.reading.nil?; end
end
