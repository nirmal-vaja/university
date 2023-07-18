class AddAbbrToRole < ActiveRecord::Migration[7.0]
  def change
    add_column :roles, :abbr, :string
  end
end
