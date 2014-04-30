class CreateKalibroModule < ActiveRecord::Migration
  def change
    create_table :kalibro_modules do |t|
      t.string :name
      t.string :granularity

      t.timestamps
    end
  end
end
