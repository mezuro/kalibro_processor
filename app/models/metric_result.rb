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

  def range
    value = self.aggregated_value
    ranges = KalibroGatekeeperClient::Entities::Range.ranges_of(metric_configuration.id)
    ranges.select { |range| range.beginning <= value && value < range.end }.first
  end

  def has_grade?
    range = self.range
    !range.nil? && !range.reading.nil?
  end

  def grade; self.range.grade; end
end
