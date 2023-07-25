class RenameConfigurationToConfig < ActiveRecord::Migration[7.0]
  def change
    rename_table :configurations, :configs
  end
end
