class RenameKalibroModuleGranularityToGranlrty < ActiveRecord::Migration
  def change
    rename_column :kalibro_modules, :granularity, :granlrty
  end
end
