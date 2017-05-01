require 'rails_helper'

RSpec.feature 'Clients:UpdateProfile', type: :feature, js: true do
  context 'clients create profile' do
    let(:client) { create :client }
    let(:client_profile) { create :client_profile, client: client }

    before do
      client_profile
      sign_on_as(client)
    end
    context 'successfull' do
      it 'should create profile by client' do
        visit client_settings_profile_path(client_username: client.username)
        expect(page).to have_selector 'h1', text: 'Update Profile'
        fill_in placeholder: 'コーポレートサイトURL', with: 'http://example1.com'
        attach_file('client_profile_logo', 'spec/fixtures/images/lobo.png')
        click_button '変更を保存'
        expect(page).to have_selector 'h2', text: "#{client.last_name} #{client.first_name}"
        client_profile.reload
        expect(client_profile.corporate_site).to eq('http://example1.com')
      end
    end
    context 'failed' do
      it 'should not create profile by client' do
        visit client_settings_profile_path(client_username: client.username)
        expect(page).to have_selector 'h1', text: 'Update Profile'
        fill_in placeholder: 'コーポレートサイトURL', with: ''
        attach_file('client_profile_logo', 'spec/fixtures/images/lobo.png')
        click_button '変更を保存'
        expect(page).to have_selector 'h1', text: 'Update Profile'
      end
    end
  end
end
