class AddSubjectIndexToExamTimeTable < ActiveRecord::Migration[7.0]
  def change
    add_index :exam_time_tables, [:subject_id, :time_table_type], unique: true
  end
end
