class RemoveProcessTimeIdFromProcessings < ActiveRecord::Migration
  def change
    change_table :processings do |t|
      t.remove :process_time_id
    end
  end
end
