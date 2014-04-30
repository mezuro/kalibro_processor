class AddModuleResultIdToKalibroModule < ActiveRecord::Migration
  def change
    add_column :kalibro_modules, :module_result_id, :integer
  end
end
