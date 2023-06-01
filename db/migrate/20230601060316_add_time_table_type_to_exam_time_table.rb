class AddTimeTableTypeToExamTimeTable < ActiveRecord::Migration[7.0]
  def change
    add_column :exam_time_tables, :time_table_type, :string
  end
end
