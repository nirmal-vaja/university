class AddReportTypeToTimeTableBlockWiseReport < ActiveRecord::Migration[7.0]
  def change
    add_column :time_table_block_wise_reports, :report_type, :string
  end
end
