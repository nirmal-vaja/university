class AddCourseIdToSubject < ActiveRecord::Migration[7.0]
  def change
    add_reference :subjects, :course, null: false, foreign_key: true
    add_reference :subjects, :branch, null: false, foreign_key: true
  end
end
