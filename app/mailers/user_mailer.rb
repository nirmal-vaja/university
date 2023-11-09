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

  def send_university_registration_mail(email, university, url, token)
    @email = email
    @university = university
    @url = url
    @token = token
    mail(to: @email, subject: "#{@university.name} has been registered.")
  end

  def send_marks_entry_notification(user, opts = {})
    @user = user
    @role_name = opts[:role_name]
    @url = opts[:url] + "?d=#{@user.secure_id}"
    @subject_names = opts[:subject_names]

    if @user.has_role?(@role_name)
      mail(to: @user.email, subject: "You are assigned as #{@role_name}")
    else
      mail(to: @user.email, subject: "You are revoked as #{@role_name}")
    end
  end
end
