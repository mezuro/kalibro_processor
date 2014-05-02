class CreateMetricResult < ActiveRecord::Migration
  def change
    create_table :metric_results do |t|
      t.integer :module_result_id
      t.integer :metric_configuration_id
      t.float :value

      t.timestamps
    end
  end
end
