class AddTimeToProcessTime < ActiveRecord::Migration
  def change
    add_column :process_times, :time, :float
  end
end
