class RemoveDepartmentFromExamTimeTable < ActiveRecord::Migration[7.0]
  def change
    remove_column :exam_time_tables, :department, :string
  end
end
