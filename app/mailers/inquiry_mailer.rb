class InquiryMailer < ApplicationMailer
  def recieved_email(inquiry)
    @inquiry = inquiry
    mail to: Settings.mail.default_to, subject: I18n.t('user_mailer.inquiry_recived.subject')
  end

  def sended_email(inquiry)
    @inquiry = inquiry
    mail to: @inquiry.email, subject: I18n.t('user_mailer.inquiry_sended.subject')
  end
end
