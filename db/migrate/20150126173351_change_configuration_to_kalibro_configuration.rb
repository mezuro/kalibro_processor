class ChangeConfigurationToKalibroConfiguration < ActiveRecord::Migration
  def change
    rename_column :repositories, :configuration_id, :kalibro_configuration_id
  end
end
