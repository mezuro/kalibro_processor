class RenameMetricResultToTreeMetricResult < ActiveRecord::Migration
  def change
    reversible do |dir|
      dir.up do
        execute <<-SQL
          UPDATE metric_results SET type = 'TreeMetricResult' WHERE type = 'MetricResult'
        SQL
      end
      dir.down do
        execute <<-SQL
          UPDATE metric_results SET type = 'MetricResult' WHERE type = 'TreeMetricResult'
        SQL
      end
    end
  end
end
