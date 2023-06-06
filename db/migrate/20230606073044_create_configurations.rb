class CreateConfigurations < ActiveRecord::Migration[7.0]
  def change
    create_table :configurations do |t|
      t.string :examination_name
      t.string :examination_type
      t.string :academic_year
      t.references :course, null: false, foreign_key: true
      t.references :branch, null: false, foreign_key: true
      t.references :semester, null: false, foreign_key: true
      t.references :division, null: false, foreign_key: true
      t.text :subject_ids
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
