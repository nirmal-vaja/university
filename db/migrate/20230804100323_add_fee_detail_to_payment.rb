class AddFeeDetailToPayment < ActiveRecord::Migration[7.0]
  def change
    add_reference :payments, :fee_detail, foreign_key: true
  end
end
