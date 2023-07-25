class RemoveSemesterFromConfiguration < ActiveRecord::Migration[7.0]
  def change
    remove_reference :configurations, :semester, null: false, foreign_key: true
    remove_reference :configurations, :division, null: false, foreign_key: true
  end
end
