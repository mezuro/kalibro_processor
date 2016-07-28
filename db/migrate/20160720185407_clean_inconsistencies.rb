require 'fileutils'

class CleanInconsistencies < ActiveRecord::Migration
  def backup_dir
    return @backup_dir if @backup_dir
    @backup_dir = Rails.root.join('db', 'backup', Time.now.strftime('%Y-%m-%d_%H-%M-%S'))
    FileUtils.mkdir_p(@backup_dir)
  end

  def backup(name, query, header: true)
    say_with_time("backup(#{name.inspect}, #{query.inspect})") do
      copy_query = "COPY (#{query}) TO STDOUT WITH DELIMITER ',' CSV #{header ? 'HEADER' : ''}"

      File.open(backup_dir.join("#{name}.csv"), 'a') do |f|
        connection.raw_connection.copy_data(copy_query) do
          while line = connection.raw_connection.get_copy_data
            f.write(line)
          end
        end
      end
    end
  end

  def backup_and_delete_missing(table, exists_query)
    backup(table, "SELECT * FROM \"#{table}\" WHERE NOT EXISTS(#{exists_query})")
    execute "DELETE FROM \"#{table}\" WHERE NOT EXISTS(#{exists_query})"
  end

  def up
    say "WARNING: destructive migration necessary. Deleted data will be backed up to #{backup_dir}"

    # Unset project reference for repositories with non-existing projects
    execute <<-SQL
      UPDATE repositories AS r
      SET project_id = NULL
      WHERE project_id = 0 OR NOT EXISTS (
        SELECT 1 FROM projects AS p WHERE p.id = r.project_id
      )
    SQL

    # Delete processings with non-existing repositories
    backup_and_delete_missing("processings",
      "SELECT 1 FROM repositories AS r WHERE r.id = processings.repository_id")

    # Delete process times with non-existing processings
    backup_and_delete_missing("process_times",
      "SELECT 1 FROM processings AS p WHERE p.id = process_times.processing_id")

    # Delete module results with non-existing processings
    backup_and_delete_missing("module_results",
      "SELECT 1 FROM processings AS p WHERE p.id = module_results.processing_id")

    # Delete kalibro modules with non-existing module results
    backup_and_delete_missing("kalibro_modules",
      "SELECT 1 FROM module_results AS m WHERE m.id = kalibro_modules.module_result_id")

    # Fix up metric results type, even before backing up so the backup is cleaner
    execute <<-SQL
      UPDATE metric_results SET "type" = 'TreeMetricResult' WHERE "type" = 'MetricResult'
    SQL

    # Delete metric results with non-existing module results
    backup_and_delete_missing("metric_results",
      "SELECT 1 FROM module_results AS m WHERE m.id = metric_results.module_result_id")

    # Delete duplicate metric_results. Group them by (module_result_id, metric_configuration_id),
    # then delete all but the one with the highest ID. The double wrapping on the inner query is
    # necessary because window functions cannot be used in WHERE in PostgreSQL.
    repeated_metric_result_query = exec_query <<-SQL
      SELECT t.id FROM (
        SELECT metric_results.*, ROW_NUMBER() OVER (
          PARTITION BY module_result_id, metric_configuration_id, "type"
          ORDER BY id DESC) AS rnum
        FROM metric_results
        WHERE "type" = 'TreeMetricResult'
      ) AS t
      WHERE t.rnum > 1
    SQL

    unless repeated_metric_result_query.empty?
      repeated_metric_result_ids = repeated_metric_result_query.rows.flat_map(&:first).join(',')

      # Replace default messages with custom ones to avoid flooding the screen with the huge query
      say_with_time('backup("metric_results", "SELECT * metric_results WHERE id IN (...)")') do
        suppress_messages do
          backup('metric_results',
            "SELECT * FROM metric_results WHERE id IN (#{repeated_metric_result_ids})",
            header: false)
        end
      end

      say_with_time('execute("DELETE FROM metric_results WHERE id IN (...)")') do
        suppress_messages do
          execute "DELETE FROM metric_results WHERE id IN (#{repeated_metric_result_ids})"
        end
      end
    end
  end

  def self.down
    raise ActiveRecord::IrreversibleMigration
  end
end
