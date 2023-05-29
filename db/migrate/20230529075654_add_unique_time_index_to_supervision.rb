class AddUniqueTimeIndexToSupervision < ActiveRecord::Migration[7.0]
  def change
    add_index :supervisions, [:user_id, :time], unique: true
  end
end
