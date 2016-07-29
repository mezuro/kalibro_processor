class AddIndexesToKalibroModules < ActiveRecord::Migration
  def change
    add_index :kalibro_modules, :module_result_id
    add_index :kalibro_modules, [:long_name, :granularity]
  end
end
