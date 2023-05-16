class CreateOtherDuties < ActiveRecord::Migration[7.0]
  def change
    create_table :other_duties do |t|
      t.references :user, null: false, foreign_key: true
      t.string :assigned_duties

      t.timestamps
    end
  end
end
