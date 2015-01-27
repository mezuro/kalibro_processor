class MetricResultAggregator
  def self.aggregated_value(metric_result)
    values = DescriptiveStatistics::Stats.new(metric_result.descendant_values)
    if metric_result.value.nil? && !values.empty?
      # descriptive-statistics gem uses the method 'mean' whereas we call 'average'
      # the method that calculates the arithmetic mean of the values
      form = metric_result.metric_configuration.aggregation_form.to_s.downcase
      form = "mean" if form == "average"

      values.send( form )
    else
      metric_result.value
    end
  end
end
