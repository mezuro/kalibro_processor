class AddIndexesOnMetricResults < ActiveRecord::Migration
  def change
		add_index :metric_results, :module_result_id
		add_index :metric_results, :metric_configuration_id
  end
end
