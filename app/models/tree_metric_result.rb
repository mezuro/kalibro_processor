class TreeMetricResult < MetricResult
  validates :metric_configuration_id, uniqueness: { scope: :module_result_id }

  def range
    ranges = KalibroClient::Entities::Configurations::KalibroRange.ranges_of(metric_configuration.id)
    ranges.detect { |range| range.range === self.value }
  end

  def has_grade?
    range = self.range
    !range.nil? && !range.reading.nil?
  end

  def grade; self.range.grade; end

  def descendant_values
    self.class.
      joins(:module_result).
      where('module_results.parent_id' => module_result_id).
      pluck(:value)
  end

  def as_json(options={})
    super(except: [:line_number, :message, :related_hotspot_metric_results_id], **options)
  end
end
