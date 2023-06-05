class AddQrcodeToStudent < ActiveRecord::Migration[7.0]
  def change
    add_column :students, :qrcode, :string
  end
end
