class CreateStudentBlocks < ActiveRecord::Migration[7.0]
  def change
    create_table :student_blocks do |t|
      t.references :block, null: false, foreign_key: true
      t.references :student, null: false, foreign_key: true

      t.timestamps
    end
  end
end
