class MetricResultAggregator
  def self.aggregated_value(metric_result)
    values = DescriptiveStatistics::Stats.new(metric_result.descendant_values)
    if metric_result.value.nil? && !values.empty?
      # descriptive-statistics gem uses the method 'mean' whereas we call 'average'
      # the method that calculates the arithmetic mean of the values
      form = metric_result.metric_configuration.aggregation_form.to_s.downcase

      if form == "average"
        form = "mean"
        puts "DEPRECATED: use mean instead of average for aggregation form"
      end

      if form == "maximum"
        form = "max"
        puts "DEPRECATED: use max instead of maximum for aggregation form"
      end

      if form == "minimum"
        form = "min"
        puts "DEPRECATED: use min instead of minimum for aggregation form"
      end

      values.send( form )
    else
      metric_result.value
    end
  end
end
