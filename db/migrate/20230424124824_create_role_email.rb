class CreateRoleEmail < ActiveRecord::Migration[7.0]
  def change
    create_table :role_emails do |t|
      t.string :email
      t.references :role, null: false, foreign_key: true

      t.timestamps
    end
  end
end
