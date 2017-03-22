require 'rails_helper'

RSpec.describe WorkerMailer, type: :mailer do
  describe 'activate_worker' do
    let(:worker) { create :worker }
    let(:mail) { WorkerMailer.activate_worker(worker) }

    it 'should valid account activation' do
      worker.activation_token = Worker.new_token
      expect(mail.subject).to eq(I18n.t('worker_mailer.sign_up.subjet'))
      expect(mail.to).to eq([worker.email])
      expect(mail.from).to eq(['from@example.com'])
      expect(mail.body.encoded).to match worker.activation_token
      expect(mail.body.encoded).to match "#{worker.first_name}さん"
    end
  end
end
