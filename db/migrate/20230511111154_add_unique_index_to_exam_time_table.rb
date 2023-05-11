class AddUniqueIndexToExamTimeTable < ActiveRecord::Migration[7.0]
  def change
    add_index :exam_time_tables, [:subject_id, :name, :academic_year], unique: true
  end
end
