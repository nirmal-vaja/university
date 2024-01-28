class AddExaminationTypeToRoomBlock < ActiveRecord::Migration[7.0]
  def change
    add_column :room_blocks, :examination_type, :string
  end
end
