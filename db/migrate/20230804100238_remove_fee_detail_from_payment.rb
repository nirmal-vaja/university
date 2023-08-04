class RemoveFeeDetailFromPayment < ActiveRecord::Migration[7.0]
  def change
    remove_reference :payments, :fee_detail, null: false, foreign_key: true
  end
end
