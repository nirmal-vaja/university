class AddDefaultEmailToRole < ActiveRecord::Migration[7.0]
  def change
    add_column :roles, :default_email, :string
  end
end
