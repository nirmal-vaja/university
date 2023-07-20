class AddAcademicYearToPayment < ActiveRecord::Migration[7.0]
  def change
    add_column :payments, :academic_year, :string
  end
end
