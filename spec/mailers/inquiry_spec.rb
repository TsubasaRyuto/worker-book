require "rails_helper"

RSpec.describe InquiryMailer, type: :mailer do
  context 'recieved_email' do
    let(:inquiry) { build :inquiry }
    let(:mail) { InquiryMailer.recieved_email(inquiry) }

    it 'should valid account activation' do
      expect(mail.subject).to eq(I18n.t('user_mailer.inquiry_recived.subject'))
      expect(mail.to).to eq([Settings.mail.default_to])
      expect(mail.from).to eq(['from@example.com'])
      expect(mail.body.encoded).to match "#{inquiry.name}さん"
    end
  end

  context 'sended_email' do
    let(:inquiry) { build :inquiry }
    let(:mail) { InquiryMailer.sended_email(inquiry) }

    it 'should valid account activation' do
      expect(mail.subject).to eq(I18n.t('user_mailer.inquiry_sended.subject'))
      expect(mail.to).to eq([inquiry.email])
      expect(mail.from).to eq(['from@example.com'])
      expect(mail.body.encoded).to match "#{inquiry.name}さん"
    end
  end
end
