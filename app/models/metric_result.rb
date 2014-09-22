class MetricResult < ActiveRecord::Base
  attr_accessor :metric
  belongs_to :module_result

  def aggregated_value
    values = self.descendant_values
    if self.value.nil? && !values.empty?
      # Fix for the period while we're using vintage Kalibro
      form = self.metric_configuration.aggregation_form.to_s.downcase
      form = "mean" if form == "average"

      values.send( form )
    else
      self.value
    end
  end

  def range
    ranges = KalibroGatekeeperClient::Entities::Range.ranges_of(metric_configuration.id)
    ranges.select { |range| range.beginning.to_f <= self.value && self.value < range.end.to_f }.first
  end

  def has_grade?
    range = self.range
    !range.nil? && !range.reading.nil?
  end

  def grade; self.range.grade; end

  def metric_configuration=(value)
    self.metric_configuration_id = value.id
  end

  def metric_configuration
    # This is a low level Rails caching
    # With this there is a HUGE speed up on the Runner
    Rails.cache.fetch("processing/#{self.module_result.processing_id}/metric_configuration/#{self.metric_configuration_id}", expires_in: Delayed::Worker.max_run_time) do
      @metric_configuration ||= KalibroGatekeeperClient::Entities::MetricConfiguration.find(self.metric_configuration_id)
    end
  end

  def descendant_values
    results = module_result.children.each { |child| child.metric_results.each { |metric_result| p metric_result.metric_configuration.metric }; p child.metric_result_for(self.metric) }
    results = module_result.children.map { |child| child.metric_result_for(self.metric).value }
    DescriptiveStatistics::Stats.new(results)
  end

  def metric
    @metric ||= self.metric_configuration.metric
  end
end
