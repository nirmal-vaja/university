class AddTypeToFacultySubjects < ActiveRecord::Migration[7.0]
  def change
    add_column :faculty_subjects, :type, :integer
  end
end
