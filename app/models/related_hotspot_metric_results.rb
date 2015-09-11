class RelatedHotspotMetricResults < ActiveRecord::Base
  has_many :hotspot_metric_results
end
