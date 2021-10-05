class CreateShrines < ActiveRecord::Migration[5.2]
  def change
    create_table :shrines do |t|
      t.string :name
      t.string :address
      t.text :introduction
      t.integer :impressions_count, default: 0
      t.float :latitude
      t.float :longitude

      t.timestamps
    end
  end
end
