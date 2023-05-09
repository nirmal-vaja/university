class RemoveCourseIdFromSemester < ActiveRecord::Migration[7.0]
  def change
    remove_reference :semesters, :course, null: false, foreign_key: true
  end
end
