class ChangeColumnOfBlockExtraConfig < ActiveRecord::Migration[7.0]
  def change
    change_column_default :block_extra_configs, :number_of_extra_jr_supervision, 0
    change_column_default :block_extra_configs, :number_of_extra_sr_supervision, 0
  end
end
