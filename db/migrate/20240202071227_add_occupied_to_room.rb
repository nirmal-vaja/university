class AddOccupiedToRoom < ActiveRecord::Migration[7.0]
  def change
    add_column :rooms, :occupied, :string
  end
end
