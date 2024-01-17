class RemoveRoomsFromTimeTableBlockWiseReport < ActiveRecord::Migration[7.0]
  def change
    remove_column :time_table_block_wise_reports, :rooms, :integer
  end
end
