class CreateSubject < ActiveRecord::Migration[7.0]
  def change
    create_table :subjects do |t|
      t.string :code
      t.string :name
      t.references :semester, null: false, foreign_key: true

      t.timestamps
    end
  end
end
