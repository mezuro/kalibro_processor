class AddCodeDirectoryToRepository < ActiveRecord::Migration
  def change
    add_column :repositories, :code_directory, :string
  end
end
