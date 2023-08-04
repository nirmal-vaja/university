class AddCertificateIdToPayment < ActiveRecord::Migration[7.0]
  def change
    add_reference :payments, :certificate, foreign_key: true
  end
end
