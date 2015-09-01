class HotspotResult < BaseMetricResult
  belongs_to :related_hotspot_results
  has_many :related_results, class_name: 'HotspotResult',
           through: :related_hotspot_results,
           source: :hotspot_results
end
