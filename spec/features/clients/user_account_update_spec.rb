require 'rails_helper'

RSpec.feature 'Clients:UserAccountUdate', type: :feature do
  context 'clients user account udpate' do
    let(:client) { create :client }
    let(:client_user) { create :client_user, client: client }
    before do
      sign_on_as(client_user)
    end
    context 'successful' do
      it 'should update user account' do
        username = 'change_username'
        email = 'change_email@example.com'
        expect(client_user.username).to_not eq username
        expect(client_user.email).to_not eq email
        visit client_client_settings_account_path(client_clientname: client.clientname, username: client_user.username)
        fill_in 'Username', with: username
        fill_in 'Email', with: email
        click_button 'Save changes'
        expect(page).to have_selector '.alert'
        client_user.reload
        expect(client_user.username).to eq username
        expect(client_user.email).to eq email
      end
    end

    context 'failed' do
      it 'should not update' do
        visit client_client_settings_account_path(client_clientname: client.clientname, username: client_user.username)
        fill_in 'Username', with: 'invali+info'
        fill_in 'Email', with: 'worker@invalid'
        click_button 'Save changes'
        expect(page).to have_selector 'h3', text: 'Information'
        expect(page).to have_selector 'div#error_explanation'
        expect(page).to have_selector 'div.field_with_errors'
      end
    end
  end
end
