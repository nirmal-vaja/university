class UserMailer < ApplicationMailer
  def send_password_change_mail(user, url)
    @user = user
    @url = url
    mail(to: "nirmalvaja123@gmail.com", subject: 'Change your password')
  end

  def role_assigned_notification(user, opts={})
    @user = user
    @role_name = opts[:role_name]
    @url = opts[:url]
    @role_email = opts[:role_email]
    mail(to: @user.email, subject: "You have been assigned #{@role_name}!")
  end

  def send_otp_mail(user)
    @user = user
    mail(to: @user.email, subject: "You recieved an OTP")
  end
end
