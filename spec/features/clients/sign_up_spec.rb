require 'rails_helper'

RSpec.feature 'ClientUsers:SingUp', type: :feature, js: true do
  context 'client users sign up' do
    before do
      ApplicationMailer.deliveries.clear
    end
    context 'valid information' do
      it 'should sign up with account activate' do
        visit '/client/sign_up'
        expect(page).to have_selector 'h1', text: 'Create Account of Client'
        fill_in placeholder: 'ex) Lobo株式会社', with: 'Test 株式会社会社'
        fill_in placeholder: 'ex) http://lobo-inc.com', with: 'http://example.com'
        fill_in placeholder: 'ex) lobo_inc', with: 'client_example'
        select '北海道', from: 'client_location'
        attach_file('client_logo', 'spec/fixtures/images/lobo.png', visible: false)
        page.find('#next-step').click
        page.execute_script("$('.fade-out').hide()")
        page.execute_script("$('#signup-client-user').show()")
        expect(page).to have_selector 'h1', text: 'Create Account of Client user'
        fill_in placeholder: 'Last Name', with: 'Foo'
        fill_in placeholder: 'First Name', with: 'Bar'
        fill_in placeholder: 'Username', with: 'foobar'
        fill_in placeholder: 'Email', with: 'foobar@example.com'
        fill_in placeholder: 'Password', with: 'foobar123'
        fill_in placeholder: 'Confirmation', with: 'foobar123'
        expect { click_button 'アカウント作成' }.to change { ClientUser.count }.by(1)
        expect(page).to have_selector 'h1', text: '会員登録はまだ完了しておりません。'
        expect(ApplicationMailer.deliveries.size).to eq 1
        client_user = ClientUser.last
        expect(client_user.activated?).to be_falsey
        # --- not activated
        sign_on_as(client_user)
        expect(signed_on?(client_user)).to be_falsey
        # ---

        mail = ApplicationMailer.deliveries.last
        mail_body = mail.body.encoded
        activation_token = mail_body.split('/')[5]

        # --- valid activate
        visit client_activate_user_path(client_clientname: client_user.client.clientname, token: activation_token, email: client_user.email)
        expect(client_user.reload.activated?).to be_truthy
        expect(signed_on?(client_user)).to be_truthy
      end
    end

    context 'invalid information' do
      it 'should not sign up' do
        visit '/client/sign_up'
        expect(page).to have_selector 'h1', text: 'Create Account of Client'
        fill_in placeholder: 'ex) Lobo株式会社', with: ''
        fill_in placeholder: 'ex) http://lobo-inc.com', with: ''
        fill_in placeholder: 'ex) lobo_inc', with: ''
        select '北海道', from: 'client_location'
        attach_file('client_logo', 'spec/fixtures/images/lobo.png', visible: false)
        page.find('#next-step').click
        page.execute_script("$('.fade-out').hide()")
        page.execute_script("$('#signup-client-user').show()")
        expect(page).to have_selector 'h1', text: 'Create Account of Client user'
        fill_in placeholder: 'Last Name', with: ''
        fill_in placeholder: 'First Name', with: ''
        fill_in placeholder: 'Username', with: 'invali+info'
        fill_in placeholder: 'Email', with: 'client@invalid'
        fill_in placeholder: 'Password', with: 'foo'
        fill_in placeholder: 'Confirmation', with: 'bar'
        expect { click_button 'アカウント作成' }.to_not change { ClientUser.count }
        expect(page).to have_selector 'h1', text: 'Create Account of Client'
        expect(page).to have_selector 'div#error_explanation'
        expect(page).to have_selector 'div.field_with_errors'
      end
    end
  end
end
