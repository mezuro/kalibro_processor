class AddIndexesToModuleResults < ActiveRecord::Migration
  def change
    add_index :module_results, :processing_id
  end
end
