class CreateShrineGods < ActiveRecord::Migration[5.2]
  def change
    create_table :shrine_gods do |t|
      t.references :shrine, foreign_key: true
      t.references :god, foreign_key: true

      t.timestamps
    end
    add_index :shrine_gods, [:shrine_id, :god_id], unique: true
  end
end
