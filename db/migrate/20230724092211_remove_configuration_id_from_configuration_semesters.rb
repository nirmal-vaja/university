class RemoveConfigurationIdFromConfigurationSemesters < ActiveRecord::Migration[7.0]
  def change
    remove_reference :configuration_semesters, :configuration, null: false, foreign_key: true
  end
end
