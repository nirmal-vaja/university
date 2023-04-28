class CreateSemester < ActiveRecord::Migration[7.0]
  def change
    create_table :semesters do |t|
      t.string :name
      t.references :course, null: false, foreign_key: true

      t.timestamps
    end
  end
end
