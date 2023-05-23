class AddCourseToOtherDuty < ActiveRecord::Migration[7.0]
  def change
    add_reference :other_duties, :course, foreign_key: true
    add_reference :other_duties, :branch, foreign_key: true
  end
end
