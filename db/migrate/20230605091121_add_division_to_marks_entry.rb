class AddDivisionToMarksEntry < ActiveRecord::Migration[7.0]
  def change
    add_reference :marks_entries, :division, null: false, foreign_key: true
  end
end
