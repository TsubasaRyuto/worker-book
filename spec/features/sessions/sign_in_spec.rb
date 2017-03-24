require 'rails_helper'

RSpec.feature 'Sessions::SignIn', type: :feature do
  context 'sign in' do
    context 'successfull' do
      let(:worker) { create :worker }
      context 'valid information' do
        it 'should sign in on remember_me' do
          visit '/sign_in'
          expect(page).to have_selector 'h1', text: 'サインイン'
          fill_in placeholder: 'Email', with: worker.email
          fill_in placeholder: 'Password', with: worker.password
          click_button 'サインイン'
          # expect(signed_on?).to be_truthy
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
          expect(page).to have_selector 'h1', text: 'サインイン'
          fill_in placeholder: 'Email', with: ''
          fill_in placeholder: 'Password', with: ''
          click_button 'サインイン'
          expect(page).to have_selector 'h1', text: 'サインイン'
          expect(page).to have_selector '.alert'
          visit root_path
          expect(page).to_not have_selector '.alert'
        end
      end

      context 'not account activation' do
        let(:worker) { create :worker, activated: false, activated_at: nil }
        it 'should not sign in' do
          visit '/sign_in'
          expect(page).to have_selector 'h1', text: 'サインイン'
          fill_in placeholder: 'Email', with: worker.email
          fill_in placeholder: 'Password', with: worker.password
          click_button 'サインイン'
          expect(page).to have_selector 'h1', text: 'WorkerBook'
          expect(page).to have_selector '.alert'
        end
      end
    end
  end
end
