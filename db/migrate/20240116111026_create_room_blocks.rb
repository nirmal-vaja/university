class CreateRoomBlocks < ActiveRecord::Migration[7.0]
  def change
    create_table :room_blocks do |t|
      t.references :block, null: false, foreign_key: true
      t.references :room, null: false, foreign_key: true

      t.timestamps
    end
  end
end
