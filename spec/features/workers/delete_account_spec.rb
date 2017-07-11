require 'rails_helper'

RSpec.feature 'Workers:DeleteAccount', type: :feature do
  context 'workers account delete' do
    context 'workers account update' do
      let(:worker) { create :worker }
      let(:worker_profile) { create :worker_profile, worker: worker }
      before do
        worker_profile
      end
      context 'successful' do
        it 'should delete account' do
          worker_email = worker.email
          worker_password = worker.password
          sign_on_as(worker)
          visit "/worker/#{worker.username}/retire"
          fill_in placeholder: 'Password Here....', with: worker.password
          expect { click_button '退会' }.to change { Worker.count }.by(-1)
          expect(page).to have_selector '.alert'

          # 削除したアカウントでのサインイン＝＞error
          visit '/sign_in'
          expect(page).to have_selector 'h1', text: 'サインイン'
          fill_in placeholder: 'メールアドレス', with: worker_email
          fill_in placeholder: 'パスワード', with: worker_password
          click_button 'サインイン'
          expect(page).to have_selector 'h1', text: 'サインイン'
          expect(page).to have_selector '.alert'
        end
      end

      context 'failed' do
        it 'should not delete' do
          sign_on_as(worker)
          visit "/worker/#{worker.username}/retire"
          fill_in placeholder: 'Password Here....', with: ''
          expect { click_button '退会' }.to change { Worker.count }.by(0)
          expect(page).to have_selector '.alert'
        end
      end
    end
  end
end
