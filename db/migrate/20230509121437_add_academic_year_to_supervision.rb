class AddAcademicYearToSupervision < ActiveRecord::Migration[7.0]
  def change
    add_column :supervisions, :academic_year, :string
  end
end
