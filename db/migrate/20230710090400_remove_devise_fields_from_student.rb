class RemoveDeviseFieldsFromStudent < ActiveRecord::Migration[7.0]
  def change
    remove_column :students, :email, :string
    remove_column :students, :encrypted_password, :string
    remove_column :students, :reset_password_token, :string
    remove_column :students, :reset_password_sent_at, :datetime
    remove_column :students, :remember_created_at, :datetime
  end
end
