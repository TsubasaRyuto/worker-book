require 'rails_helper'

RSpec.describe WorkerMailer, type: :mailer do
  context 'activate_worker' do
    let(:worker) { create :worker }
    let(:mail) { WorkerMailer.activate_worker(worker) }

    it 'should valid account activation' do
      worker.activation_token = Worker.new_token
      expect(mail.subject).to eq(I18n.t('user_mailer.sign_up.subject'))
      expect(mail.to).to eq([worker.email])
      expect(mail.from).to eq(['from@example.com'])
      expect(mail.body.encoded).to match worker.activation_token
      expect(mail.body.encoded).to match "#{worker.first_name}さん"
    end
  end

  context 'password_reset' do
    let(:worker) { create :worker }
    let(:mail) { WorkerMailer.password_reset(worker) }

    it 'should valid account activation' do
      worker.reset_token = Worker.new_token
      expect(mail.subject).to eq(I18n.t('user_mailer.rset_pass.subject'))
      expect(mail.to).to eq([worker.email])
      expect(mail.from).to eq(['from@example.com'])
      expect(mail.body.encoded).to match worker.reset_token
    end
  end

  context 'request_job' do
    let(:worker) { create :worker }
    let(:client) { create :client }
    let(:job_content) { create :job_content, client: client }
    let(:job_request) { create :job_request, job_content: job_content, worker: worker }
    let(:mail) { WorkerMailer.request_job(worker, client, job_content, job_request) }
    before do
      Timecop.travel(Date.new(2017, 01, 01)) do
        job_content
      end
    end

    it 'should valid account activation' do
      job_request.activation_token = Worker.new_token
      expect(mail.subject).to eq(I18n.t('user_mailer.job_request.subject'))
      expect(mail.to).to eq([worker.email])
      expect(mail.from).to eq(['from@example.com'])
      expect(mail.body.encoded).to match job_request.activation_token
    end
  end
end
