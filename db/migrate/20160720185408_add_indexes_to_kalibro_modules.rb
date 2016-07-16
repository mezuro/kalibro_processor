class AddIndexesToKalibroModules < ActiveRecord::Migration
  def change
    add_foreign_key :kalibro_modules, :module_results, on_delete: :cascade
    add_index :kalibro_modules, [:long_name, :granularity]
  end
end
