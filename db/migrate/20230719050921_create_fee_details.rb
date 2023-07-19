class CreateFeeDetails < ActiveRecord::Migration[7.0]
  def change
    create_table :fee_details do |t|
      t.string :amount
      t.references :course, null: false, foreign_key: true
      t.references :branch, null: false, foreign_key: true
      t.references :semester, null: false, foreign_key: true

      t.timestamps
    end
  end
end
