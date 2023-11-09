class AddAdminEmailToUniversity < ActiveRecord::Migration[7.0]
  def change
    add_column :universities, :admin_email, :string
  end
end
