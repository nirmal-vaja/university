class AddBranchToSemester < ActiveRecord::Migration[7.0]
  def change
    add_reference :semesters, :branch, null: false, foreign_key: true
  end
end
