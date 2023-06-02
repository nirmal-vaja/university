class RemoveIndexFromExamTimeTable < ActiveRecord::Migration[7.0]
  def change
    remove_index :exam_time_tables, [:subject_id, :name, :academic_year]
  end
end
