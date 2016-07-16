class AddIndexesToModuleResults < ActiveRecord::Migration
  def change
    add_foreign_key :module_results, :module_results, column: 'parent_id'
    add_foreign_key :module_results, :processings, on_delete: :cascade
  end
end
