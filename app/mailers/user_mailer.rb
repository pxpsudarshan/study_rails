class UserMailer < ApplicationMailer
  def notify(name, email, job_description)
    @user_name = name
    @job = job_description
    mail(to: email, subject: "Applied to this position.")
  end
end
