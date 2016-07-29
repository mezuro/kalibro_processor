class AddIndexesToRepositories < ActiveRecord::Migration
  def change
    add_index :repositories, :project_id
  end
end
