class AddUniqueIndexToSupervision < ActiveRecord::Migration[7.0]
  def change
    add_index :supervisions, [:user_id, :list_type], unique: true
    add_index :supervisions, [:user_id, :examination_name], unique: true
    add_index :supervisions, [:user_id, :academic_year], unique: true
  end
end
