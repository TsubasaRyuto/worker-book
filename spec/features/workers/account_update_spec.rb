require 'rails_helper'

RSpec.feature 'Workers:AccountUpdate', type: :feature do
  context 'workers account update' do
    let(:worker) { create :worker }
    let(:worker_profile) { create :worker_profile, worker: worker }
    before do
      worker_profile
    end
    context 'successful' do
      it 'should sign up with account activate' do
        sign_on_as(worker)
        visit '/worker/sign_up'
        visit "/#{worker.username}/settings/account"
        fill_in 'Username', with: 'change_username'
        fill_in 'Email', with: 'change_email@exmaple.com'
        click_button 'Save changes'
        expect(page).to have_selector 'div', text: "アカウント情報を変更いたしました"
        worker.reload
        expect(worker.username).to eq('change_username')
        expect(worker.username).to eq('change_username')
      end
    end

    context 'failed' do
      it 'should not sign up' do
        sign_on_as(worker)
        visit "/#{worker.username}/settings/account"
        fill_in 'Username', with: 'invali+info'
        fill_in 'Email', with: 'worker@invalid'
        click_button 'Save changes'
        expect(page).to have_selector 'h3', text: "Information"
        expect(page).to have_selector 'div#error_explanation'
        expect(page).to have_selector 'div.field_with_errors'
      end
    end
  end
end
