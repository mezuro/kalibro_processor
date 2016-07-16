class AddIndexesOfForeignKeys < ActiveRecord::Migration
  def change
    add_index :module_results, :processing_id
    add_index :kalibro_modules, :module_result_id
    add_index :process_times, :processing_id
    add_index :processings, :repository_id
    add_index :repositories, :project_id 
  end
end
