class CreateDivisions < ActiveRecord::Migration[7.0]
  def change
    create_table :divisions do |t|
      t.references :semester, null: false, foreign_key: true
      t.string :name

      t.timestamps
    end
  end
end
