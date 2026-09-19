class UserMailer < ApplicationMailer
  def notify(name, email, job_description)
    @user_name = name
    @job = job_description
    mail(to: email, subject: "Applied to this position.")
  end

  def verify_email(name, email, token)
    @user_name = name
    @api_token = token
    mail(to: email, subject: "Verify Email.")
  end
end
