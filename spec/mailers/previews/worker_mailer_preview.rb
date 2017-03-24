# Preview all emails at http://localhost:3000/rails/mailers/worker_mailer
class WorkerMailerPreview < ActionMailer::Preview
  def activate_worker
    def activate_worker
      worker = Worker.first_name
      worker.activation_token = Worker.new_token
      WorkerMailer.activate_worker(worker)
    end
  end
end
