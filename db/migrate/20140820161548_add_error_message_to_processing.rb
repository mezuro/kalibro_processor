class AddErrorMessageToProcessing < ActiveRecord::Migration
  def change
    add_column :processings, :error_message, :text
  end
end
