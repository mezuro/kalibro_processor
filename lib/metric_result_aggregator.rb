class MetricResultAggregator
  def self.aggregated_value(metric_result)
    values = DescriptiveStatistics::Stats.new(metric_result.descendant_values)
    if metric_result.value.nil? && !values.empty?
      aggregation_form = metric_result.metric_configuration.aggregation_form.to_s.downcase
      values.send(aggregation_form)
    else
      metric_result.value
    end
  end
end
