class RenameKalibroModuleNameToLongName < ActiveRecord::Migration
  def change
    rename_column :kalibro_modules, :name, :long_name
  end
end
