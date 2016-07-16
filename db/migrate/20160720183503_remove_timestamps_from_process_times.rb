class RemoveTimestampsFromProcessTimes < ActiveRecord::Migration
  def change
    remove_column :process_times, :created_at, :string
    remove_column :process_times, :updated_at, :string
  end
end
