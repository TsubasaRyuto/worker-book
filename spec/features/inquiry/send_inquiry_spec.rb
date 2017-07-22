require 'rails_helper'

RSpec.feature 'Inquiry:SendInquiry', type: :feature do
  let(:name) { Faker::Name.name }
  let(:email) { 'test_user@example.com' }
  let(:inquiry_title) { 'テストタイトル' }
  let(:message) { Faker::Lorem.sentence }
  context 'send Inquiry' do
    context 'successfull' do
      it 'should send inquiry' do
        visit inquiry_path
        expect(page).to have_selector 'h1', text: 'お問い合わせ'
        fill_in '名前', with: name
        fill_in 'メールアドレス', with: email
        fill_in 'お問い合わせ件名', with: inquiry_title
        fill_in 'お問い合わせ内容', with: message
        click_button '確認画面へ'
        expect(page).to have_selector 'h1', text: 'お問い合わせ内容確認'
        click_button '送信'
        expect(page).to have_selector 'h1', text: 'お問い合わせ送信完了'
        expect(ApplicationMailer.deliveries.size).to eq 2
      end
    end

    context 'failed' do
      it 'should not send inquiry' do
        visit inquiry_path
        expect(page).to have_selector 'h1', text: 'お問い合わせ'
        fill_in '名前', with: ''
        fill_in 'メールアドレス', with: ''
        fill_in 'お問い合わせ件名', with: inquiry_title
        fill_in 'お問い合わせ内容', with: message
        click_button '確認画面へ'
        expect(page).to have_selector 'h1', text: 'お問い合わせ'
      end
    end
  end
end
