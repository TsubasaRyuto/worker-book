require 'rails_helper'

RSpec.feature 'Workers:SingUp', type: :feature do
  context 'workers sign up' do
    before do
      ApplicationMailer.deliveries.clear
    end
    context 'invalid information' do
      it 'should not sign up' do
        visit '/worker/sign_up'
        fill_in placeholder: '名前-氏', with: ''
        fill_in placeholder: '名前-名', with: ''
        fill_in placeholder: 'ユーザーネーム', with: 'invali+info'
        fill_in placeholder: 'メールアドレス', with: 'worker@invalid'
        fill_in placeholder: 'パスワード', with: 'foo'
        fill_in placeholder: 'パスワード確認', with: 'bar'
        expect { click_button 'アカウント作成' }.to_not change { Worker.count }
        expect(page).to have_selector 'h1', text: 'フリーランスアカウント'
        expect(page).to have_selector 'div#error_explanation'
        expect(page).to have_selector 'div.field_with_errors'
      end
    end

    context 'valid information' do
      it 'should sign up with account activate' do
        visit '/worker/sign_up'
        fill_in placeholder: '名前-氏', with: 'Foo'
        fill_in placeholder: '名前-名', with: 'Bar'
        fill_in placeholder: 'ユーザーネーム', with: 'foobar'
        fill_in placeholder: 'メールアドレス', with: 'foobar@example.com'
        fill_in placeholder: 'パスワード', with: 'foobar123'
        fill_in placeholder: 'パスワード確認', with: 'foobar123'
        expect { click_button 'アカウント作成' }.to change { Worker.count }.by(1)
        expect(page).to have_selector 'h1', text: '会員登録はまだ完了しておりません。'
        expect(ApplicationMailer.deliveries.size).to eq 1
        worker = Worker.last
        expect(worker.activated?).to be_falsey
        # --- not activated
        sign_on_as(worker)
        expect(signed_on?(worker)).to be_falsey
        # ---
        mail = ApplicationMailer.deliveries.last
        mail_body = mail.body.encoded
        activation_token = mail_body.split('/')[4]

        # --- valid activate
        visit activate_worker_path(activation_token, email: worker.email)
        expect(worker.reload.activated?).to be_truthy
        expect(signed_on?(worker)).to be_truthy
        expect(page).to have_selector 'h1', text: 'フリーランスアカウント'
        expect(page).to have_selector 'h2', text: 'プロフィール登録'
      end
    end
  end
end
