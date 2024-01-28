class AddTimeTableIdToBlock < ActiveRecord::Migration[7.0]
  def change
    add_reference :blocks, :exam_time_table, null: false, foreign_key: true
  end
end
