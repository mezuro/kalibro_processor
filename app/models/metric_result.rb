class MetricResult < ActiveRecord::Base
  attr_accessor :metric
  belongs_to :module_result

      form = "max" if form == "maximum"
      form = "min" if form == "minimum"
  def range
    ranges = KalibroClient::Configurations::KalibroRange.ranges_of(metric_configuration.id)
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
      @metric_configuration ||= KalibroClient::Configurations::MetricConfiguration.find(self.metric_configuration_id)
    end
  end

  def descendant_values
    results = module_result.children.map { |child| child.metric_result_for(self.metric).value }
  end

  def metric
    @metric ||= self.metric_configuration.metric
  end
end
