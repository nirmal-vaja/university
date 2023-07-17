class AddGenderToStudent < ActiveRecord::Migration[7.0]
  def change
    add_column :students, :gender, :string
    add_column :students, :father_name, :string
    add_column :students, :mother_name, :string
    add_column :students, :date_of_birth, :string
    add_column :students, :birth_place, :string
    add_column :students, :religion, :string
    add_column :students, :caste, :string
    add_column :students, :nationality, :string
    add_column :students, :mother_tongue, :string
    add_column :students, :marrital_status, :string
    add_column :students, :blood_group, :string
    add_column :students, :physically_handicapped, :boolean, default: :false
  end
end
