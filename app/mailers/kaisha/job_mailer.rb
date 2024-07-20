class Kaisha::JobMailer < ApplicationMailer
  def notify(kaisha_name, kaisha_email, occupation, job_description, entry_no)
    @kaisha_name = kaisha_name
    @occupation = occupation
    @job = job_description
    @entry_no = entry_no
    mail(to: kaisha_email, subject: "Job Apply from User")
  end
end
