class RemoveTimestampsFromKalibroModules < ActiveRecord::Migration
  def change
    remove_column :kalibro_modules, :created_at, :string
    remove_column :kalibro_modules, :updated_at, :string
  end
end
