require 'rails_helper'

RSpec.feature 'Clients:CreateProfile', type: :feature, js: true do
  context 'clients create profile' do
    let(:client) { create :client }
    context 'successfull' do
      it 'should create profile by client' do
        sign_on_as(client)
        visit client_create_profile_path(client_username: client.username)
        expect(page).to have_selector 'h1', text: 'Create Profile'
        fill_in placeholder: 'コーポレートサイトURL', with: 'http://example.com'
        attach_file('client_profile_logo', 'spec/fixtures/images/lobo.png')
        expect { click_button '詳細登録' }.to change { ClientProfile.count }.by(1)
        expect(page).to have_selector 'h2', text: "#{client.last_name} #{client.first_name}"
      end
    end
    context 'failed' do
      it 'should not create profile by client' do
        sign_on_as(client)
        visit client_create_profile_path(client_username: client.username)
        expect(page).to have_selector 'h1', text: 'Create Profile'
        fill_in placeholder: 'コーポレートサイトURL', with: ''
        attach_file('client_profile_logo', 'spec/fixtures/images/lobo.png')
        expect { click_button '詳細登録' }.to change { ClientProfile.count }.by(0)
        expect(page).to have_selector 'h1', text: 'Create Profile'
      end
    end
  end
end
