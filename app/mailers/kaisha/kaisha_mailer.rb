class Kaisha::KaishaMailer < ApplicationMailer
  def notify(email, kaisha_email, kaisha_name, occupation, entry_no)
    @email = kaisha_email
    @entry_no = entry_no
    @occupation = occupation
    @kaisha_name = kaisha_name
    mail(to: email, subject: "Matching Info Request")
  end
end
