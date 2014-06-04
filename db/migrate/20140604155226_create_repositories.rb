class CreateRepositories < ActiveRecord::Migration
  def change
    create_table :repositories do |t|
      t.string :name
      t.string :scm_type
      t.string :address
      t.string :description, default: ""
      t.string :license, default: ""
      t.integer :period, default: 0

      t.timestamps
    end
  end
end
