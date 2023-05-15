class AddExaminationNameToSupervision < ActiveRecord::Migration[7.0]
  def change
    add_column :supervisions, :examination_name, :string
  end
end
