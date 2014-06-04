class AddConfigurationIdToRepository < ActiveRecord::Migration
  def change
    add_column :repositories, :configuration_id, :integer
  end
end
