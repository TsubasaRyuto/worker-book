require 'rails_helper'

RSpec.feature 'Sessions::SignOut', type: :feature do
  context 'Sign out' do
    context 'successfull' do
      shared_examples_for 'user sign out' do
        before do
          profile
        end
        it 'should sign out' do
          visit '/sign_in'
          expect(signed_on?(user)).to be_falsey
          expect(page).to have_selector 'h1', text: 'Sign In'
          fill_in placeholder: 'Email', with: user.email
          fill_in placeholder: 'Password', with: user.password
          click_button 'Sign In'
          expect(signed_on?(user)).to be_truthy
          click_link 'Sign out'
          expect(page).to have_selector 'h1', text: 'WorkerBook'
          expect(page).to have_link 'Sign in', href: '/sign_in'
          expect(page).to have_link 'Sign up', href: '/sign_up'
          expect(signed_on?(user)).to be_falsey
          expect(current_path).to eq root_path

        end
      end

      context 'worker' do
        it_behaves_like 'user sign out' do
          let(:user) { create :worker }
          let(:profile) { create :worker_profile, worker: user }
        end
      end

      context 'client' do
        it_behaves_like 'user sign out' do
          let(:profile) { create :client }
          let(:user) { create :client_user, client: profile }
        end
      end
    end
  end
end
