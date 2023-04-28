class CreateFacultyMarksEntries < ActiveRecord::Migration[7.0]
  def change
    create_table :faculty_marks_entries do |t|
      t.references :user, null: false, foreign_key: true
      t.references :course, null: false, foreign_key: true
      t.references :semester, null: false, foreign_key: true
      t.references :subject, null: false, foreign_key: true

      t.timestamps
    end
  end
end
