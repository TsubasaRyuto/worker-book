require 'rails_helper'

RSpec.feature 'Sessions::SignOut', type: :feature do
  context 'Sign out' do
    context 'successfull' do
      let(:worker) { create :worker }
      let(:profile) { create :worker_profile, worker: worker }
      it 'should sign in on remember_me' do
        visit '/sign_in'
        expect(page).to have_selector 'h1', text: 'Sign In'
        fill_in placeholder: 'Email', with: worker.email
        fill_in placeholder: 'Password', with: worker.password
        click_button 'Sign In'
        expect(signed_on?(worker)).to be_truthy
        expect(page).to have_selector 'h1', text: 'Create Profile'
        click_link 'Sign out', href: '/sign_out'
        expect(signed_on?(worker)).to be_falsey
        expect(page).to have_selector 'h1', text: 'WorkerBook'
        expect(page).to have_link 'Sign in', href: '/sign_in'
        expect(page).to have_link 'Sign up', href: '/sign_up'
      end
    end
  end
end
