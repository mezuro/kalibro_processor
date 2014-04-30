class CreateModuleResult < ActiveRecord::Migration
  def change
    create_table :module_results do |t|
      t.float :grade
      t.integer :parent_id
      t.integer :height

      t.timestamps
    end
  end
end
