class MetricResult < ActiveRecord::Base
  attr_accessor :metric
  belongs_to :module_result

  def aggregated_value
    values = self.descendant_values
    if self.value.nil? && !values.empty?
      # Fix for while we're using vintage Kalibro
      form = self.metric_configuration.aggregation_form.to_s.downcase
      form = "mean" if form == "average"

      values.send( form )
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

  def metric_configuration=(value)
    self.metric_configuration_id = value.id
  end

  def metric_configuration
    KalibroGatekeeperClient::Entities::MetricConfiguration.find(self.metric_configuration_id)
  end

  def descendant_values
    results = module_result.children.map { |child| child.metric_result_for(self.metric).value  }
    DescriptiveStatistics::Stats.new(results)
  end

  def metric
    @metric ||= self.metric_configuration.metric
  end
end
