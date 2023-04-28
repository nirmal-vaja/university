class CreateMarksEntries < ActiveRecord::Migration[7.0]
  def change
    create_table :marks_entries do |t|
      t.string :enrollment_number
      t.references :subject, null: false, foreign_key: true
      t.string :marks

      t.timestamps
    end
  end
end
