class AddTypeToMetricResults < ActiveRecord::Migration
  def change
    add_column :metric_results, :type, :string, index: true, null: false, default: 'MetricResult'
  end
end
