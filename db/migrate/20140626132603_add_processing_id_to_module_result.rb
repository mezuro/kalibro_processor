class AddProcessingIdToModuleResult < ActiveRecord::Migration
  def change
    add_column :module_results, :processing_id, :integer
  end
end
