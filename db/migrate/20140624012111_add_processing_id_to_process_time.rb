class AddProcessingIdToProcessTime < ActiveRecord::Migration
  def change
    add_column :process_times, :processing_id, :integer
  end
end
