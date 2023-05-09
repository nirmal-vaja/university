class CreateTimeTableBlockWiseReports < ActiveRecord::Migration[7.0]
  def change
    create_table :time_table_block_wise_reports do |t|
      t.references :exam_time_table, null: false, foreign_key: true
      t.integer :rooms
      t.integer :blocks

      t.timestamps
    end
  end
end
