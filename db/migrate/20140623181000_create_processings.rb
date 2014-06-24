class CreateProcessings < ActiveRecord::Migration
  def change
    create_table :processings do |t|
      t.string :state
      t.integer :process_time_id
      t.integer :repository_id

      t.timestamps
    end
  end
end
