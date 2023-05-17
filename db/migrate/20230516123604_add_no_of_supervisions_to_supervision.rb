class AddNoOfSupervisionsToSupervision < ActiveRecord::Migration[7.0]
  def change
    add_column :supervisions, :no_of_supervisions, :integer
  end
end
