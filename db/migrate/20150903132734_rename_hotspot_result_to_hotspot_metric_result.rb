class RenameHotspotResultToHotspotMetricResult < ActiveRecord::Migration
  def change
    reversible do |dir|
      dir.up do
        execute <<-SQL
          UPDATE metric_results SET type = 'HotspotMetricResult' WHERE type = 'HotspotResult'
        SQL
      end
      dir.down do
        execute <<-SQL
          UPDATE metric_results SET type = 'HotspotResult' WHERE type = 'HotspotMetricResult'
        SQL
      end
    end
    rename_column :metric_results, :related_hotspot_results_id, :related_hotspot_metric_results_id
  end
end
