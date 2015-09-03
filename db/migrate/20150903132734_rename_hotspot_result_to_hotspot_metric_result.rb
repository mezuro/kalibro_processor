class RenameHotspotResultToHotspotMetricResult < ActiveRecord::Migration
  def change
    BaseMetricResult.where(type: 'HotspotResult').update_all(type: 'HotspotMetricResult')
    rename_column :metric_results, :related_hotspot_results_id, :related_hotspot_metric_results_id
  end
end
