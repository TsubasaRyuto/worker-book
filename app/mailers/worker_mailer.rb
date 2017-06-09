class WorkerMailer < ApplicationMailer
  def activate_worker(worker)
    @worker = worker
    mail to: @worker.email, subject: I18n.t('user_mailer.sign_up.subject')
  end

  def update_account
    @worker = worker
    mail to: @worker.email, subject: I18n.t('user_mailer.update.subject')
  end

  def password_reset(worker)
    @worker = worker
    mail to: @worker.email, subject: I18n.t('user_mailer.rset_pass.subject')
  end

  def request_job(worker, client, job_content, job_request)
    @worker = worker
    @client = client
    @job_content = job_content
    @job_request = job_request
    mail to: @worker.email, subject: I18n.t('user_mailer.job_request.subject')
  end
end
