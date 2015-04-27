class RemoveHeightFromModuleResult < ActiveRecord::Migration
  def change
    remove_column :module_results, :height
  end
end
