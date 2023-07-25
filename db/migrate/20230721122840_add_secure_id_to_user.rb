class AddSecureIdToUser < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :secure_id, :text
  end
end
