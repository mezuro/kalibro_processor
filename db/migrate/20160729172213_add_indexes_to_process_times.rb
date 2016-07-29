class AddIndexesToProcessTimes < ActiveRecord::Migration
  def change
    add_index :process_times, :processing_id
  end
end
