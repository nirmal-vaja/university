class AddExaminationNameToRoomBlock < ActiveRecord::Migration[7.0]
  def change
    add_column :room_blocks, :examination_name, :string
    add_column :room_blocks, :academic_year, :string
    add_reference :room_blocks, :course, null: false, foreign_key: true
    add_reference :room_blocks, :branch, null: false, foreign_key: true
    add_column :room_blocks, :date, :date
    add_column :room_blocks, :time, :string
  end
end
