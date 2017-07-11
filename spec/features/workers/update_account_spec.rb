require 'rails_helper'

RSpec.feature 'Workers:UpdateAccount', type: :feature do
  context 'workers account update' do
    let(:worker) { create :worker }
    let(:worker_profile) { create :worker_profile, worker: worker }
    before do
      worker_profile
    end
    context 'successful' do
      it 'should update account' do
        username = 'change_username'
        email = 'change_email@example.com'
        sign_on_as(worker)
        visit worker_settings_account_path(username: worker.username)
        fill_in 'ユーザーネーム', with: username
        fill_in 'メールアドレス', with: email
        find_button('変更を保存').trigger('click')
        expect(page).to have_selector '.alert'
        worker.reload
        expect(worker.username).to eq username
        expect(worker.email).to eq email
      end
    end

    context 'failed' do
      it 'should not update' do
        sign_on_as(worker)
        visit worker_settings_account_path(username: worker.username)
        fill_in 'ユーザーネーム', with: 'invali+info'
        fill_in 'メールアドレス', with: 'worker@invalid'
        find_button('変更を保存').trigger('click')
        expect(page).to have_selector 'h3', text: 'アカウント情報'
        expect(page).to have_selector 'div#error_explanation'
        expect(page).to have_selector 'div.field_with_errors'
      end
    end
  end
end
