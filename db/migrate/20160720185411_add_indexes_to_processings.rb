class AddIndexesToProcessings < ActiveRecord::Migration
  def change
    add_foreign_key :processings, :repositories
    add_foreign_key :processings, :module_results, column: 'root_module_result_id'
  end
end
