class AddRazorpayOrderIdToPayment < ActiveRecord::Migration[7.0]
  def change
    add_column :payments, :razorpay_order_id, :string
  end
end
