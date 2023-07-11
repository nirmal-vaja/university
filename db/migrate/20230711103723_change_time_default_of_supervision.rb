class ChangeTimeDefaultOfSupervision < ActiveRecord::Migration[7.0]
  def change
    change_column :supervisions, :time, :string, default: ""
    #Ex:- change_column("admin_users", "email", :string, :limit =>25)
  end
end
