class ClientUserMailer < ApplicationMailer
  def activate_client(client)
    @client_user = client
    mail to: @client_user.email, subject: I18n.t('user_mailer.sign_up.subjet')
  end

  def update_account
    @client_user = client
    mail to: @client_user.email, subject: I18n.t('user_mailer.update.subjet')
  end

  def password_reset(client)
    @client_user = client
    mail to: @client_user.email, subject: I18n.t('user_mailer.rset_pass.subjet')
  end
end
