class RemoveTimeTableBlockWiseReportIdFromBlock < ActiveRecord::Migration[7.0]
  def change
    remove_reference :blocks, :time_table_block_wise_report, null: false, foreign_key: true
  end
end
