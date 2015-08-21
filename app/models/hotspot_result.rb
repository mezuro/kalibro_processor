class HotspotResult < BaseMetricResult
  has_and_belongs_to_many :related_results, class_name: 'HotspotResult',
                          join_table: 'related_hotspot_results',
                          foreign_key: 'hotspot_result_id',
                          association_foreign_key: 'other_hotspot_result_id'

  def add_relation(other_hotspot_result)
    self.transaction do
      self.related_results << other_hotspot_result
      other_hotspot_result.related_results << self
    end
  end

  def remove_relation(other_hotspot_result)
    self.transaction do
      self.related_results.delete(other_hotspot_result)
      other_hotspot_result.related_results.delete(self)
    end
  end
end
