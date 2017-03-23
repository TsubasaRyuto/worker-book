class WorkerMailer < ApplicationMailer
  def activate_worker(worker)
    @worker = worker
    mail to: @worker.email, subject: I18n.t('worker_mailer.sign_up.subjet')
  end
end
