class WorkerMailer < ApplicationMailer
  def activate_worker(worker)
    @worker = worker
    mail to: @worker.email, subject: I18n.t('user_mailer.sign_up.subjet')
  end

  def update_account
    @worker = worker
    mail to: @worker.email, subject: I18n.t('user_mailer.update.subjet')
  end

  def password_reset(worker)
    @worker = worker
    mail to: @worker.email, subject: I18n.t('user_mailer.rset_pass.subjet')
  end
end
