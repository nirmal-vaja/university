class CreateBlocks < ActiveRecord::Migration[7.0]
  def change
    create_table :blocks do |t|
      t.references :time_table_block_wise_report, null: false, foreign_key: true
      t.string :name
      t.string :academic_year
      t.string :examination_name
      t.references :course, null: false, foreign_key: true
      t.references :branch, null: false, foreign_key: true
      t.references :semester, null: false, foreign_key: true

      t.timestamps
    end
  end
end
