class ApplicationMailer < ActionMailer::Base
  default from: Rails.env.development? ? 'no-reply@study.kanrin.biz' : "no-reply@ni-ho.com"
  layout "mailer"
end
