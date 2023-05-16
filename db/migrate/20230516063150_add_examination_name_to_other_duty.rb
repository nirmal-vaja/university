class AddExaminationNameToOtherDuty < ActiveRecord::Migration[7.0]
  def change
    add_column :other_duties, :examination_name, :string
    add_column :other_duties, :academic_year, :string
  end
end
