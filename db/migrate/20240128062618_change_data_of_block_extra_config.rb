class ChangeDataOfBlockExtraConfig < ActiveRecord::Migration[7.0]
  def change
    rename_column :block_extra_configs, :data, :date
    #Ex:- rename_column("admin_users", "pasword","hashed_pasword")
  end
end
