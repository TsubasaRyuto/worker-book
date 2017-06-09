class ClientUserMailer < ApplicationMailer
  def activate_client(client)
    @client_user = client
    mail to: @client_user.email, subject: I18n.t('user_mailer.sign_up.subject')
  end

  def update_account
    @client_user = client
    mail to: @client_user.email, subject: I18n.t('user_mailer.update.subject')
  end

  def password_reset(client)
    @client_user = client
    mail to: @client_user.email, subject: I18n.t('user_mailer.rset_pass.subject')
  end

  def request_agreement(client, worker, job_content)
    @client_user = client
    @worker = worker
    @job_content = job_content
    mail to: @client_user.email, subject: I18n.t('user_mailer.request_agreement.subject')
  end

  def request_refusal(client, worker, job_content)
    @client_user = client
    @worker = worker
    @job_content = job_content
    mail to: @client_user.email, subject: I18n.t('user_mailer.request_refusal.subject')
  end
end
