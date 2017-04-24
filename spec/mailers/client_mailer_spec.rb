require "rails_helper"

RSpec.describe ClientMailer, type: :mailer do
  describe 'activate_client' do
    let(:client) { create :client }
    let(:mail) { ClientMailer.activate_client(client) }

    it 'should valid account activation' do
      client.activation_token = Client.new_token
      expect(mail.subject).to eq(I18n.t('user_mailer.sign_up.subjet'))
      expect(mail.to).to eq([client.email])
      expect(mail.from).to eq(['from@example.com'])
      expect(mail.body.encoded).to match client.activation_token
      expect(mail.body.encoded).to match "#{client.company_name} #{client.last_name}様"
    end
  end
end
