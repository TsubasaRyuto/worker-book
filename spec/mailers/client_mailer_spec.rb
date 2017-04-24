require "rails_helper"

RSpec.describe ClientMailerMailer, type: :mailer do
  describe 'activate_client' do
    let(:client) { create :client }
    let(:mail) { WorkerMailer.activate_client(client) }

    it 'should valid account activation' do
      client.activation_token = Client.new_token
      expect(mail.subject).to eq(I18n.t('user_mailer.sign_up.subjet'))
      expect(mail.to).to eq([client.email])
      expect(mail.from).to eq(['from@example.com'])
      expect(mail.body.encoded).to match client.activation_token
      expect(mail.body.encoded).to match "#{client.first_name}さん"
    end
  end
end
