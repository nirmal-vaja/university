class RemoveIndexFromSupervision < ActiveRecord::Migration[7.0]
  def change
    remove_index :supervisions, [:user_id, :examination_name]
    remove_index :supervisions, [:user_id, :academic_year]
  end
end
