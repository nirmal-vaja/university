class ChangeOccupiedOfRoom < ActiveRecord::Migration[7.0]
  def change
    change_column :rooms, :capacity, :integer, default: 0, using: 'capacity::integer'
    change_column :rooms, :occupied, :integer, default: 0, using: 'occupied::integer'
  end
end
