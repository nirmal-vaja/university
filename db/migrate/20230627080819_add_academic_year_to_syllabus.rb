class AddAcademicYearToSyllabus < ActiveRecord::Migration[7.0]
  def change
    add_column :syllabuses, :academic_year, :string
  end
end
