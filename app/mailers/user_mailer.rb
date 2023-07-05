class UserMailer < ApplicationMailer
  def send_password_change_mail(user, url)
    @user = user
    @url = url
    mail(to: "nirmalvaja123@gmail.com", subject: 'Change your password')
  end
end
