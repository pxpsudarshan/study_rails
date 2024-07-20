class ApplicationMailer < ActionMailer::Base
  default from: Rails.env.development? ? 'nobody@study.kanrin.biz' : "nobody@ni-ho.com"
  layout "mailer"
end
