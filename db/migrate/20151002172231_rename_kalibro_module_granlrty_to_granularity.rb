class RenameKalibroModuleGranlrtyToGranularity < ActiveRecord::Migration
  def change
    rename_column :kalibro_modules, :granlrty, :granularity
  end
end
