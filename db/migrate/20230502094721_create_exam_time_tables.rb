class CreateExamTimeTables < ActiveRecord::Migration[7.0]
  def change
    create_table :exam_time_tables do |t|
      t.string :name
      t.string :department
      t.references :semester, null: false, foreign_key: true
      t.references :subject, null: false, foreign_key: true
      t.text :day
      t.date :date
      t.text :time

      t.timestamps
    end
  end
end
