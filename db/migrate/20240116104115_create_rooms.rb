class CreateRooms < ActiveRecord::Migration[7.0]
  def change
    create_table :rooms do |t|
      t.references :course, null: false, foreign_key: true
      t.references :branch, null: false, foreign_key: true
      t.string :floor
      t.integer :room_number
      t.string :capacity

      t.timestamps
    end
  end
end
