class AddShowToUser < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :show, :boolean, default: :true
  end
end
