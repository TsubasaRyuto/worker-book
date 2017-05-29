require 'rails_helper'

RSpec.describe ClientUserMailer, type: :mailer do
  context'activate_client' do
    let(:client) { create :client }
    let(:client_user) { create :client_user, client: client }
    let(:mail) { ClientUserMailer.activate_client(client_user) }

    it 'should valid account activation' do
      client_user.activation_token = ClientUser.new_token
      expect(mail.subject).to eq(I18n.t('user_mailer.sign_up.subject'))
      expect(mail.to).to eq([client_user.email])
      expect(mail.from).to eq(['from@example.com'])
      expect(mail.body.encoded).to match client_user.activation_token
      expect(mail.body.encoded).to match "#{client.name} #{client_user.last_name}様"
    end
  end

  context 'password_reset' do
    let(:client) { create :client }
    let(:client_user) { create :client_user, client: client }
    let(:mail) { ClientUserMailer.password_reset(client_user) }

    it 'should valid account activation' do
      client_user.reset_token = ClientUser.new_token
      expect(mail.subject).to eq(I18n.t('user_mailer.rset_pass.subject'))
      expect(mail.to).to eq([client_user.email])
      expect(mail.from).to eq(['from@example.com'])
      expect(mail.body.encoded).to match client_user.reset_token
    end
  end

  context 'password_reset' do
    let(:client) { create :client }
    let(:client_user) { create :client_user, client: client }
    let(:mail) { ClientUserMailer.password_reset(client_user) }

    it 'should valid account activation' do
      client_user.reset_token = ClientUser.new_token
      expect(mail.subject).to eq(I18n.t('user_mailer.rset_pass.subject'))
      expect(mail.to).to eq([client_user.email])
      expect(mail.from).to eq(['from@example.com'])
      expect(mail.body.encoded).to match client_user.reset_token
    end
  end

  context 'request_agreement' do
    let(:client) { create :client }
    let(:client_user) { create :client_user, client: client }
    let(:job_content) { create :job_content, client: client }
    let(:worker) { create :worker }
    let(:mail) { ClientUserMailer.request_agreement(client_user, worker, job_content) }
    before do
      Timecop.travel(Date.new(2017,01,01)) do
        job_content
      end
    end

    it 'should valid account activation' do
      expect(mail.subject).to eq(I18n.t('user_mailer.request_agreement.subject'))
      expect(mail.to).to eq([client_user.email])
      expect(mail.from).to eq(['from@example.com'])
    end
  end

  context 'request_refusal' do
    let(:client) { create :client }
    let(:client_user) { create :client_user, client: client }
    let(:job_content) { create :job_content, client: client }
    let(:worker) { create :worker }
    let(:mail) { ClientUserMailer.request_refusal(client_user, worker, job_content) }
    before do
      Timecop.travel(Date.new(2017,01,01)) do
        job_content
      end
    end

    it 'should valid account activation' do
      expect(mail.subject).to eq(I18n.t('user_mailer.request_refusal.subject'))
      expect(mail.to).to eq([client_user.email])
      expect(mail.from).to eq(['from@example.com'])
    end
  end
end
