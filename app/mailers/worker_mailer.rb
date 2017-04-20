class WorkerMailer < ApplicationMailer
  def activate_worker(worker)
    @worker = worker
    mail to: @worker.email, subject: I18n.t('worker_mailer.sign_up.subjet')
  end

  def update_account
    @worker = worker
    mail to: @worker.email, subject: I18n.t('worker_mailer.update.subjet')
  end

  def password_reset
  end
end
