class AddUserToMarksEntry < ActiveRecord::Migration[7.0]
  def change
    add_reference :marks_entries, :user, null: false, foreign_key: true
    add_column :marks_entries, :examination_name, :string
    add_column :marks_entries, :academic_year, :string
    add_reference :marks_entries, :course, null: false, foreign_key: true
    add_reference :marks_entries, :branch, null: false, foreign_key: true
    add_reference :marks_entries, :semester, null: false, foreign_key: true
    add_column :marks_entries, :entry_type, :integer
  end
end
