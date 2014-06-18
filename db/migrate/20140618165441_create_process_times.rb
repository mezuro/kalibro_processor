class CreateProcessTimes < ActiveRecord::Migration
  def change
    create_table :process_times do |t|
      t.string :state

      t.timestamps
    end
  end
end
