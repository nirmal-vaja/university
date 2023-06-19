class AddPublishMarksToStudentMarks < ActiveRecord::Migration[7.0]
  def change
    add_column :student_marks, :publish_marks, :boolean, default: false
  end
end
