class AddBranchToExamTimeTable < ActiveRecord::Migration[7.0]
  def change
    add_reference :exam_time_tables, :branch, null: false, foreign_key: true
  end
end
