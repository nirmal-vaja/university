class AddDayToExamTimeTable < ActiveRecord::Migration[7.0]
  def change
    add_column :exam_time_tables, :day, :integer
  end
end
