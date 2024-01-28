class CreateBlockExtraConfigs < ActiveRecord::Migration[7.0]
  def change
    create_table :block_extra_configs do |t|
      t.string :examination_name
      t.string :academic_year
      t.references :course, null: false, foreign_key: true
      t.references :branch, null: false, foreign_key: true
      t.date :data
      t.string :time
      t.integer :number_of_extra_jr_supervision
      t.integer :number_of_extra_sr_supervision

      t.timestamps
    end
  end
end
