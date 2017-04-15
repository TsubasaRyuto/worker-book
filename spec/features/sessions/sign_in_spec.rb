require 'rails_helper'

RSpec.feature 'Sessions::SignIn', type: :feature do
  context 'sign in' do
    context 'successfull' do
      let(:worker) { create :worker }
      let(:profile) { create :worker_profile, worker: worker }
      context 'valid information but not create profile' do
        it 'should sign in on remember_me' do
          visit '/sign_in'
          expect(page).to have_selector 'h1', text: 'Sign In'
          fill_in placeholder: 'Email', with: worker.email
          fill_in placeholder: 'Password', with: worker.password
          click_button 'Sign In'
          expect(signed_on?(worker)).to be_truthy
          expect(page).to have_selector 'h1', text: 'Create Profile'
          expect(page).to have_link worker.username.to_s
          expect(page).to have_link 'Sign out', href: '/sign_out'
          expect(page).to have_link 'Settings', href: worker_settings_profile_path(worker_username: worker.username)
        end
      end

      context 'valid information and created profile' do
        before do
          profile
        end
        it 'should sign in on remember_me' do
          visit '/sign_in'
          expect(page).to have_selector 'h1', text: 'Sign In'
          fill_in placeholder: 'Email', with: worker.email
          fill_in placeholder: 'Password', with: worker.password
          click_button 'Sign In'
          expect(signed_on?(worker)).to be_truthy
          expect(page).to have_selector 'h2', text: "#{worker.last_name} #{worker.first_name}"
          expect(page).to have_link worker.username.to_s
          expect(page).to have_link 'Sign out', href: '/sign_out'
          expect(page).to have_link 'Settings', href: worker_settings_profile_path(worker_username: worker.username)
        end
      end

      context 'with remember_me' do
        it 'login with remembering' do
          sign_on_as(worker, remember_me: '1')
          expect(page.driver.cookies['remember_token']).to be_present
        end
      end

      context 'with not remember_me' do
        it 'login with remembering' do
          sign_on_as(worker, remember_me: '0')
          expect(page.driver.cookies['remember_token']).to be_blank
        end
      end
    end

    context 'faild' do
      context 'invalid information' do
        it 'should not sign in' do
          visit '/sign_in'
          expect(page).to have_selector 'h1', text: 'Sign In'
          fill_in placeholder: 'Email', with: ''
          fill_in placeholder: 'Password', with: ''
          click_button 'Sign In'
          expect(page).to have_selector 'h1', text: 'Sign In'
          expect(page).to have_selector '.alert'
          visit root_path
          expect(page).to_not have_selector '.alert'
        end
      end

      context 'not account activation' do
        let(:worker) { create :worker, activated: false, activated_at: nil }
        it 'should not sign in' do
          visit '/sign_in'
          expect(page).to have_selector 'h1', text: 'Sign In'
          fill_in placeholder: 'Email', with: worker.email
          fill_in placeholder: 'Password', with: worker.password
          click_button 'Sign In'
          expect(page).to have_selector 'h1', text: 'WorkerBook'
          expect(page).to have_selector '.alert'
        end
      end
    end
  end
end
