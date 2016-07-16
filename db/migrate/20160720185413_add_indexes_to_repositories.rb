class AddIndexesToRepositories < ActiveRecord::Migration
  def change
    add_foreign_key :repositories, :projects
  end
end
