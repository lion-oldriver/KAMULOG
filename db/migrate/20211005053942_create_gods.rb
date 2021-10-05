class CreateGods < ActiveRecord::Migration[5.2]
  def change
    create_table :gods do |t|
      t.string :god_name

      t.timestamps
    end
  end
end
