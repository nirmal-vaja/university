class CreatePayments < ActiveRecord::Migration[7.0]
  def change
    create_table :payments do |t|
      t.references :fee_detail, null: false, foreign_key: true
      t.references :student, null: false, foreign_key: true
      t.string :status
      t.string :razorpay_payment_id
      t.text :razorpay_payment_url

      t.timestamps
    end
  end
end
