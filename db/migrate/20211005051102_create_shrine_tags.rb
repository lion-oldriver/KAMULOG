class CreateShrineTags < ActiveRecord::Migration[5.2]
  def change
    create_table :shrine_tags do |t|
      t.references :shrine, foreign_key: true
      t.references :tag, foreign_key: true

      t.timestamps
    end
    add_index :shrine_tags, [:shrine_id, :tag_id], unique: true
  end
end
