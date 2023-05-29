class RemoveUniqueIndexFromSupervision < ActiveRecord::Migration[7.0]
  def change
    remove_index :supervisions, [:user_id, :list_type]
    remove_index :supervisions, [:user_id, :time]
  end
end
