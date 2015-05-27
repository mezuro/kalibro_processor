class AddColumnBranchToRepository < ActiveRecord::Migration
  def change
    add_column :repositories, :branch, :string
  end
end
