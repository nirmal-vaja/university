require 'twilio-ruby'

class OtpSender
  def initialize(phone_number, otp)
    @phone_numner = phone_number
    @otp = otp
  end

  def call
    client = Twilio::REST::Client.new(
      ENV["TWILIO_ACCOUNT_SID"],
      ENV["TWILIO_AUTH_TOKEN"]
    )

    client.messages.create(
      from: ENV["TWILIO_SENDER_PHONE"],
      to: @phone_numner,
      body: "Your OTP is: #{@otp}"
    )
  end
end