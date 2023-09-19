class StudentMailer < ApplicationMailer
  def send_otp_mail(student)
    @student = student
    mail(to: @student.contact_details.personal_email_address, subject: 'You received an OTP')
  end
end