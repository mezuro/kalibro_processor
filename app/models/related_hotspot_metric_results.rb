class RelatedHotspotMetricResults < ActiveRecord::Base
  has_many :hotspot_metric_results, class_name: 'HotspotMetricResult'
end
