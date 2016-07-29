class AddIndexesToProcessings < ActiveRecord::Migration
  def change
    add_index :processings, :repository_id
  end
end
