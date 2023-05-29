class AddUniqueIndexingToSupervision < ActiveRecord::Migration[7.0]
  def change
    add_index :supervisions, [:user_id, :list_type, :time], unique: true
  end
end
