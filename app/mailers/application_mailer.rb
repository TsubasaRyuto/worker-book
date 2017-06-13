class ApplicationMailer < ActionMailer::Base
  default from: Settings.mail.default_from
  layout 'mailer'
end
