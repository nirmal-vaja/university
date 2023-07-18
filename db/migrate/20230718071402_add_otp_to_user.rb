class AddOtpToUser < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :otp, :string
    add_column :users, :otp_generated_at, :datetime
  end
end
