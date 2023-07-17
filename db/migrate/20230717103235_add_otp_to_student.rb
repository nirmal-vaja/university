class AddOtpToStudent < ActiveRecord::Migration[7.0]
  def change
    add_column :students, :otp, :string
    add_column :students, :otp_generated_at, :datetime
  end
end
