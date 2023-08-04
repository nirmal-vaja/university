class AddPaymentTypeToPayment < ActiveRecord::Migration[7.0]
  def change
    add_column :payments, :payment_type, :string
  end
end
