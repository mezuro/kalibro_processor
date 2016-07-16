class RemoveTimestampsFromMetricResults < ActiveRecord::Migration
  def change
    remove_column :metric_results, :created_at, :string
    remove_column :metric_results, :updated_at, :string
  end
end
