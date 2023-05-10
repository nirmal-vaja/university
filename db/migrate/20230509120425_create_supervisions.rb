class CreateSupervisions < ActiveRecord::Migration[7.0]
  def change
    create_table :supervisions do |t|
      t.references :user, null: false, foreign_key: true
      t.text :metadata

      t.timestamps
    end
  end
end
