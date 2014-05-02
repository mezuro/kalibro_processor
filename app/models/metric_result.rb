class MetricResult < ActiveRecord::Base
  attr_reader :metric
  attr_accessor :descendant_results
  belongs_to :module_result

  def initialize(attributes={})
    super
    @metric = self.metric_configuration.metric
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

  def metric_configuration=(value)
    self.metric_configuration_id = value.id
  end

  def metric_configuration
    KalibroGatekeeperClient::Entities::MetricConfiguration.find(self.metric_configuration_id)
  end
end
