class ChangeBlocks < ActiveRecord::Migration[7.0]
  def change
    rename_column :time_table_block_wise_reports, :blocks, :number_of_blocks
    #Ex:- rename_column("admin_users", "pasword","hashed_pasword")
  end
end
