class AddMaximumMarksToExaminationType < ActiveRecord::Migration[7.0]
  def change
    add_column :examination_types, :maximum_marks, :string
  end
end
