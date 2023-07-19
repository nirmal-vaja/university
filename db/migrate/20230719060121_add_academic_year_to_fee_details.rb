class AddAcademicYearToFeeDetails < ActiveRecord::Migration[7.0]
  def change
    add_column :fee_details, :academic_year, :string
  end
end
