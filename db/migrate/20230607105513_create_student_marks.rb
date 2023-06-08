class CreateStudentMarks < ActiveRecord::Migration[7.0]
  def change
    create_table :student_marks do |t|
      t.string :examination_name
      t.string :examination_type
      t.string :academic_year
      t.references :course, null: false, foreign_key: true
      t.references :branch, null: false, foreign_key: true
      t.references :semester, null: false, foreign_key: true
      t.references :division, null: false, foreign_key: true
      t.references :subject, null: false, foreign_key: true
      t.string :marks
      t.boolean :lock_marks, default: false

      t.timestamps
    end
  end
end
