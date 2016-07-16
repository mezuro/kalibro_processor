class CleanInconsistencies < ActiveRecord::Migration
  def self.up
    # Unset project reference for repositories with non-existing projects
    execute <<-SQL
      UPDATE repositories AS r
      SET project_id = NULL
      WHERE project_id = 0 OR NOT EXISTS (
        SELECT 1 FROM projects AS p WHERE p.id = r.project_id
      )
    SQL

    # Delete processings with non-existing repositories
    execute <<-SQL
      DELETE FROM processings AS p
      WHERE NOT EXISTS(
        SELECT 1 FROM repositories AS r WHERE r.id = p.repository_id
      )
    SQL

    # Delete process times with non-existing processings
    execute <<-SQL
      DELETE FROM process_times AS t
      WHERE NOT EXISTS (
        SELECT 1 FROM processings AS p WHERE p.id = t.processing_id
      )
    SQL

    # Delete module results with non-existing processings
    execute <<-SQL
      DELETE FROM module_results AS m
      WHERE NOT EXISTS (
        SELECT 1 FROM processings AS p WHERE p.id = m.processing_id
      )
    SQL

    # Delete kalibro modules with non-existing module results
    execute <<-SQL
      DELETE FROM kalibro_modules AS k
      WHERE NOT EXISTS (
        SELECT 1 FROM module_results AS m WHERE m.id = k.module_result_id
      )
    SQL

    # Delete metric results with non-existing module results
    execute <<-SQL
      DELETE FROM metric_results AS met
      WHERE NOT EXISTS (
        SELECT 1 FROM module_results AS mod WHERE mod.id = met.module_result_id
      )
    SQL

    # Delete duplicate metric_results. Group them by (module_result, metric_configuration),
    # then delete all but the one with the highest ID
    # The double wrapping on the inner query is necessary because window functions
    # cannot be used in WHERE in PostgreSQL.
    execute <<-SQL
      DELETE FROM metric_results
      WHERE id IN (
        SELECT t.id FROM (
          SELECT id, ROW_NUMBER() OVER (PARTITION BY module_result_id, metric_configuration_id, "type"
                                        ORDER BY id DESC) AS rnum
          FROM metric_results
          WHERE "type" = 'TreeMetricResult'
        ) AS t
        WHERE t.rnum > 1
      )
    SQL
  end

  def self.down
    raise ActiveRecord::IrreversibleMigration
  end
end
