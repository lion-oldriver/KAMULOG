class CreatePosts < ActiveRecord::Migration[5.2]
  def change
    create_table :posts do |t|
      t.references :user, foreign_key: true
      t.references :shrine, foreign_key: true
      t.text :body
      t.date :visit_date

      t.timestamps
    end
  end
end
