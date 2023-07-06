class CustomDeviseMailer < Devise::Mailer
  def reset_password_instructions(record, token, opts={})
    @url = opts[:url]

    super
  end
end