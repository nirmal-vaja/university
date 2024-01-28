class AddExaminationTypeToBlockExtraConfig < ActiveRecord::Migration[7.0]
  def change
    add_column :block_extra_configs, :examination_type, :string
  end
end
