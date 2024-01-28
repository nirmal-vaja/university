class AddNumberOfSupervisionsToBlockExtraConfig < ActiveRecord::Migration[7.0]
  def change
    add_column :block_extra_configs, :number_of_supervisions, :integer
  end
end
