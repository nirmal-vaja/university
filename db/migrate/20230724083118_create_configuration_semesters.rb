class CreateConfigurationSemesters < ActiveRecord::Migration[7.0]
  def change
    create_table :configuration_semesters do |t|
      t.references :configuration, null: false, foreign_key: true
      t.references :semester, null: false, foreign_key: true
      t.references :division, null: false, foreign_key: true
      t.text :subject_ids

      t.timestamps
    end
  end
end
