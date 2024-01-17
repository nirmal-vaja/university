class AddFieldsToStudentBlock < ActiveRecord::Migration[7.0]
  def change
    add_column :student_blocks, :examination_name, :string
    add_column :student_blocks, :academic_year, :string
    add_reference :student_blocks, :course, null: false, foreign_key: true
    add_reference :student_blocks, :branch, null: false, foreign_key: true
    add_reference :student_blocks, :semester, null: false, foreign_key: true
  end
end
