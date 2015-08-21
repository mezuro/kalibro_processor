class CreateHotspotResult < ActiveRecord::Migration
  def change
    add_column :metric_results, :line_number, :integer
    add_column :metric_results, :message, :text
  end
end
