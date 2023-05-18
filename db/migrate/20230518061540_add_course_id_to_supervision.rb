class AddCourseIdToSupervision < ActiveRecord::Migration[7.0]
  def change
    add_reference :supervisions, :course, null: false, foreign_key: true
    add_reference :supervisions, :branch, null: false, foreign_key: true
    add_reference :supervisions, :semester, null: false, foreign_key: true
  end
end
