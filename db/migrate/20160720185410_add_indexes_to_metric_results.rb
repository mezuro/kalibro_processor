class AddIndexesToMetricResults < ActiveRecord::Migration
  def change
    add_foreign_key :metric_results, :module_results, on_delete: :cascade
    add_index :metric_results, :type
    add_index :metric_results, :module_result_id
    add_index :metric_results, :metric_configuration_id
    add_index :metric_results, [:module_result_id, :metric_configuration_id],
              unique: true, where: "type = 'TreeMetricResult'",
              name: 'metric_results_module_res_metric_cfg_uniq_idx'
  end
end
