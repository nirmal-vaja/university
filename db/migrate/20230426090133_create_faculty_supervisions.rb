class CreateFacultySupervisions < ActiveRecord::Migration[7.0]
  def change
    create_table :faculty_supervisions do |t|
      t.references :user, null: false, foreign_key: true
      t.references :subject, null: false, foreign_key: true
      t.datetime :data
      t.string :time

      t.timestamps
    end
  end
end
