class RemoveSubjectFromMarksEntry < ActiveRecord::Migration[7.0]
  def change
    remove_reference :marks_entries, :subject, null: false, foreign_key: true
    remove_column :marks_entries, :enrollment_number
    remove_column :marks_entries, :marks
  end
end
