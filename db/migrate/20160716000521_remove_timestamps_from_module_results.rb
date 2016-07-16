class RemoveTimestampsFromModuleResults < ActiveRecord::Migration
  def change
    remove_column :module_results, :created_at, :string
    remove_column :module_results, :updated_at, :string
  end
end
