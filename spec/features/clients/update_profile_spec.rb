require 'rails_helper'

RSpec.feature 'Clients:UpdateProfile', type: :feature, js: true do
  context 'clients create profile' do
    let(:client) { create :client }
    let(:client_user) { create :client_user, client: client }

    before do
      client
      sign_on_as(client_user)
    end
    context 'successfull' do
      it 'should create profile by client_user' do
        visit client_settings_profile_path(clientname: client.clientname)
        expect(client.corporate_site).to eq('http://example.com')
        fill_in placeholder: 'ex) Lobo株式会社', with: 'Test 株式会社会社'
        fill_in placeholder: 'ex) http://lobo-inc.com', with: 'http://example1.com'
        fill_in placeholder: 'ex) lobo_inc', with: 'client_example'
        select '北海道', from: 'client_location'
        attach_file('client_logo', 'spec/fixtures/images/lobo.png')
        click_button '変更を保存'
        client.reload
        expect(client.corporate_site).to eq('http://example1.com')
      end
    end
    context 'failed' do
      it 'should not create profile by client_user' do
        visit client_settings_profile_path(clientname: client.clientname)
        expect(page).to have_selector 'h1', text: 'Update Client profile'
        fill_in placeholder: 'ex) Lobo株式会社', with: ''
        fill_in placeholder: 'ex) http://lobo-inc.com', with: ''
        fill_in placeholder: 'ex) lobo_inc', with: 'client_example'
        select '北海道', from: 'client_location'
        attach_file('client_logo', 'spec/fixtures/images/lobo.png')
        click_button '変更を保存'
        expect(page).to have_selector 'h1', text: 'Update Client profile'
      end
    end
  end
end
