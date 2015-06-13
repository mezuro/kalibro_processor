class AddDefaultValueToRepositoryBranch < ActiveRecord::Migration
  def up
    change_column :repositories, :branch, :string, null: false, default: 'master'
  end

  def down
    change_column :repositories, :branch, :string, null: true, default: nil
  end
end
