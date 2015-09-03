class RenameMetricResultToTreeMetricResult < ActiveRecord::Migration
  def change
    BaseMetricResult.where(type: 'MetricResult').update_all(type: 'TreeMetricResult')
  end
end
