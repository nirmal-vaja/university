class RemoveSemesterIdFromStudentBlock < ActiveRecord::Migration[7.0]
  def change
    remove_reference :student_blocks, :semester, null: false, foreign_key: true
  end
end
