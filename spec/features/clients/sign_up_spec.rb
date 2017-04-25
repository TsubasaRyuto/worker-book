require 'rails_helper'

RSpec.feature 'Clients:SingUp', type: :feature do
  context 'clients sign up' do
    before do
      ApplicationMailer.deliveries.clear
    end
    context 'invalid information' do
      it 'should not sign up' do
        visit '/client/sign_up'
        fill_in placeholder: 'Last Name', with: ''
        fill_in placeholder: 'First Name', with: ''
        fill_in placeholder: 'Username', with: 'invali+info'
        fill_in placeholder: 'Company Name', with: ''
        fill_in placeholder: 'Email', with: 'client@invalid'
        fill_in placeholder: 'Password', with: 'foo'
        fill_in placeholder: 'Confirmation', with: 'bar'
        expect { click_button 'アカウント作成' }.to_not change { Client.count }
        expect(page).to have_selector 'h1', text: 'Create Account of Client'
        expect(page).to have_selector 'div#error_explanation'
        expect(page).to have_selector 'div.field_with_errors'
      end
    end

    context 'valid information' do
      it 'should sign up with account activate' do
        visit '/client/sign_up'
        fill_in placeholder: 'Last Name', with: 'Foo'
        fill_in placeholder: 'First Name', with: 'Bar'
        fill_in placeholder: 'Username', with: 'foobar'
        fill_in placeholder: 'Company Name', with: 'Test 株式会社会社'
        fill_in placeholder: 'Email', with: 'foobar@example.com'
        fill_in placeholder: 'Password', with: 'foobar123'
        fill_in placeholder: 'Confirmation', with: 'foobar123'
        expect { click_button 'アカウント作成' }.to change { Client.count }.by(1)
        expect(page).to have_selector 'h1', text: '会員登録はまだ完了しておりません。'
        expect(ApplicationMailer.deliveries.size).to eq 1
        client = Client.last
        expect(client.activated?).to be_falsey
        # --- not activated
        sign_on_as(client)
        expect(signed_on?(client)).to be_falsey
        # ---

        # --- invalid token of activate
        visit activate_client_url('invalid token')
        expect(signed_on?(client)).to be_falsey
        # ---
        mail = ApplicationMailer.deliveries.last
        mail_body = mail.body.encoded
        activation_token = mail_body.split('/')[4]

        # --- valid token but email is invalid
        visit activate_client_url(activation_token, email: 'invalid email')
        expect(signed_on?(client)).to be_falsey
        # ---

        # --- valid activate
        visit activate_client_path(activation_token, email: client.email)
        expect(client.reload.activated?).to be_truthy
        expect(signed_on?(client)).to be_truthy
        expect(page).to have_selector 'h1', text: 'Create Profile'
      end
    end
  end
end
