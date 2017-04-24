class ClientMailer < ApplicationMailer
  def activate_client(client)
    @client = client
    mail to: @client.email, subject: I18n.t('user_mailer.sign_up.subjet')
  end

  def update_account
    @client = client
    mail to: @client.email, subject: I18n.t('user_mailer.update.subjet')
  end

  def password_reset(client)
    @client = client
    mail to: @client.email, subject: I18n.t('user_mailer.rset_pass.subjet')
  end
end
