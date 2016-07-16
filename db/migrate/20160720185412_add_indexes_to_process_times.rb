class AddIndexesToProcessTimes < ActiveRecord::Migration
  def change
    add_foreign_key :process_times, :processings, on_delete: :cascade
  end
end
