class RemoveUniqueIndexesFromSupervision < ActiveRecord::Migration[7.0]
  def change
    remove_index :supervisions, [:user_id, :list_type, :time]
  end
end
