class AddDivisionIdToStudents < ActiveRecord::Migration[7.0]
  def change
    add_reference :students, :division, null: false, foreign_key: true
  end
end
