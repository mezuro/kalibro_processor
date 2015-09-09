class RenameRelatedHotspotResultsToRelatedHotspotMetricResults < ActiveRecord::Migration
  def change
    rename_table :related_hotspot_results, :related_hotspot_metric_results
  end
end
