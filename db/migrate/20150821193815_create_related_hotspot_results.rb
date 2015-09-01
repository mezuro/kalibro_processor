class CreateRelatedHotspotResults < ActiveRecord::Migration
  def change
    # This table only has an id
    create_table :related_hotspot_results

    add_column :metric_results, :related_hotspot_results_id, :integer
    add_index :metric_results, :related_hotspot_results_id
    add_foreign_key :metric_results, :related_hotspot_results, column: :related_hotspot_results_id
  end
end
