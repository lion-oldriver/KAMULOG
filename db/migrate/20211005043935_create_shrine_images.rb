class CreateShrineImages < ActiveRecord::Migration[5.2]
  def change
    create_table :shrine_images do |t|
      t.references :shrine, foreign_key: true
      t.string :image_id

      t.timestamps
    end
  end
end
