class CreateRelatedHotspotResults < ActiveRecord::Migration
  def change
    create_table :related_hotspot_results do |t|
      t.references :hotspot_result, references: :metric_results, foreign_key: false
      t.references :other_hotspot_result, references: :metric_results, index: true, foreign_key: false
    end

    add_foreign_key :related_hotspot_results, :metric_results, column: :hotspot_result_id, primary_key: :id
    add_foreign_key :related_hotspot_results, :metric_results, column: :other_hotspot_result_id, primary_key: :id

    add_index :related_hotspot_results, [:hotspot_result_id, :other_hotspot_result_id], name: 'related_hotspot_unique', unique: true
  end
end
