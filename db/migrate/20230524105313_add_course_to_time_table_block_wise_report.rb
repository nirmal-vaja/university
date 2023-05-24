class AddCourseToTimeTableBlockWiseReport < ActiveRecord::Migration[7.0]
  def change
    add_reference :time_table_block_wise_reports, :course, null: false, foreign_key: true
    add_reference :time_table_block_wise_reports, :branch, foreign_key: true
    add_reference :time_table_block_wise_reports, :semester, foreign_key: true
  end
end
