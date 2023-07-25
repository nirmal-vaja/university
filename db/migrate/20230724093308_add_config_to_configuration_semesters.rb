class AddConfigToConfigurationSemesters < ActiveRecord::Migration[7.0]
  def change
    add_reference :configuration_semesters, :config, null: false, foreign_key: true
  end
end
