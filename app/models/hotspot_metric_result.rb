class HotspotMetricResult < MetricResult
  belongs_to :related_hotspot_metric_results
  has_many :related_results, class_name: 'HotspotMetricResult',
           through: :related_hotspot_metric_results,
           source: :hotspot_metric_results

  def as_json(options={})
    super(except: [:value, :related_hotspot_metric_results_id], **options)
  end
end
