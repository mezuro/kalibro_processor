class CreateRepositories < ActiveRecord::Migration
  def change
    create_table :repositories do |t|
      t.string :name
      t.string :scm_type
      t.string :address
      t.string :description
      t.string :license
      t.integer :period

      t.timestamps
    end
  end
end
