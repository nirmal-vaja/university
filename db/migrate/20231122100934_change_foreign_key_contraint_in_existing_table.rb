class ChangeForeignKeyContraintInExistingTable < ActiveRecord::Migration[7.0]
  def change
    change_column_null :payments, :certificate_id, true
    change_column_null :payments, :fee_detail_id, true
  end
end
