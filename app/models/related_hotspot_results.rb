class RelatedHotspotResults < ActiveRecord::Base
  has_many :hotspot_results, class_name: 'HotspotResult'
end
