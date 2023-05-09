class AddAcademicYearToExamTimeTable < ActiveRecord::Migration[7.0]
  def change
    add_column :exam_time_tables, :academic_year, :string
  end
end
