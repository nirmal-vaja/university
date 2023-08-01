require 'twilio-ruby'

class OtpSender
  def initialize(phone_number, otp)
    @phone_number = "+91 " + phone_number.to_s
    @otp = otp
  end

  def call
    client = Twilio::REST::Client.new(
      "AC57f2548bc9785e5733976d64640883b9",
      "26772ec813ec4c27e24f04f44392744b"
    )

    client.messages.create(
      from: "+18148317008",
      to: @phone_number,
      body: "Your OTP is: #{@otp}"
    )
  end
end