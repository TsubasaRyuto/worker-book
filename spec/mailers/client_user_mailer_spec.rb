require 'rails_helper'

RSpec.describe ClientUserMailer, type: :mailer do
  context'activate_client' do
    let(:client) { create :client }
    let(:client_user) { create :client_user, client: client }
    let(:mail) { ClientUserMailer.activate_client(client_user) }

    it 'should valid account activation' do
      client_user.activation_token = ClientUser.new_token
      expect(mail.subject).to eq(I18n.t('user_mailer.sign_up.subjet'))
      expect(mail.to).to eq([client_user.email])
      expect(mail.from).to eq(['from@example.com'])
      expect(mail.body.encoded).to match client_user.activation_token
      expect(mail.body.encoded).to match "#{client.name} #{client_user.last_name}様"
    end
  end
end
