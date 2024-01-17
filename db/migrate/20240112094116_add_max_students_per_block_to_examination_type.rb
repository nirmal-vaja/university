class AddMaxStudentsPerBlockToExaminationType < ActiveRecord::Migration[7.0]
  def change
    add_column :examination_types, :max_studentsper_block, :integer
  end
end
