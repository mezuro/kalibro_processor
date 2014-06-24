class AddRootModuleResultIdToProcessing < ActiveRecord::Migration
  def change
    add_column :processings, :root_module_result_id, :integer
  end
end
