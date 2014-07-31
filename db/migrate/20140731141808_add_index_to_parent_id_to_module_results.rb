class AddIndexToParentIdToModuleResults < ActiveRecord::Migration
  def change
    add_index :module_results, :parent_id
  end
end
