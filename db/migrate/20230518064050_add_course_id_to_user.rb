class AddCourseIdToUser < ActiveRecord::Migration[7.0]
  def change
    add_reference :users, :course, foreign_key: true
    add_reference :users, :branch, foreign_key: true
  end
end
