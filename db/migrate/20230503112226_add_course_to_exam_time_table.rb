class AddCourseToExamTimeTable < ActiveRecord::Migration[7.0]
  def change
    add_reference :exam_time_tables, :course, null: false, foreign_key: true
  end
end
