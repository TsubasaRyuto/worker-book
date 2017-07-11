require 'rails_helper'

RSpec.feature 'Sessions::SignIn', type: :feature do
  context 'sign in' do
    context 'successfull' do
      shared_examples_for 'valid information but not create profile' do
        it 'should sign in on remember_me' do
          visit '/sign_in'
          expect(page).to have_selector 'h1', text: 'サインイン'
          fill_in placeholder: 'メールアドレス', with: user.email
          fill_in placeholder: 'パスワード', with: user.password
          click_button 'サインイン'
          expect(signed_on?(user)).to be_truthy
          expect(page).to have_selector 'h1', text: 'フリーランスアカウント'
          expect(page).to have_selector 'h2', text: 'プロフィール登録'
          expect(page).to have_link user.username.to_s
          expect(page).to have_link 'Sign out', href: '/sign_out'
        end
      end

      shared_examples_for 'valid information and created profile' do
        before do
          profile
        end
        it 'should sign in on remember_me' do
          visit '/sign_in'
          expect(page).to have_selector 'h1', text: 'サインイン'
          fill_in placeholder: 'メールアドレス', with: user.email
          fill_in placeholder: 'パスワード', with: user.password
          click_button 'サインイン'
          expect(signed_on?(user)).to be_truthy

          if user_type(user) == 'worker'
            expect(page).to have_selector 'h2', text: "#{user.last_name} #{user.first_name}"
            expect(page).to have_link user.username.to_s
          else
            expect(page).to have_selector 'h2', text: profile.name.to_s
            expect(page).to have_link profile.name.to_s
          end
          expect(page).to have_link 'Sign out', href: '/sign_out'
        end
      end

      shared_examples_for 'with remember_me' do
        it 'sign in with remembering' do
          sign_on_as(user, remember_me: '1')
          expect(page.driver.cookies['remember_token']).to be_present
        end
      end

      shared_examples_for 'with not remember_me' do
        it 'sign in with remembering' do
          sign_on_as(user, remember_me: '0')
          expect(page.driver.cookies['remember_token']).to be_blank
        end
      end

      context 'worker' do
        it_behaves_like 'valid information but not create profile' do
          let(:user) { create :worker }
          let(:delete_url) { "/worker/#{user.username}/retire" }
        end

        it_behaves_like 'valid information and created profile' do
          let(:user) { create :worker }
          let(:profile) { create :worker_profile, worker: user }
        end

        it_behaves_like 'with remember_me' do
          let(:user) { create :worker }
        end

        it_behaves_like 'with not remember_me' do
          let(:user) { create :worker }
        end
      end

      context 'client' do
        let(:client) { create :client }
        it_behaves_like 'valid information and created profile' do
          let(:profile) { create :client }
          let(:user) { create :client_user, client: profile }
        end

        it_behaves_like 'with not remember_me' do
          let(:user) { create :client_user, client: client }
        end

        it_behaves_like 'with remember_me' do
          let(:user) { create :client_user, client: client }
        end
      end
    end

    context 'failed' do
      context 'invalid information' do
        it 'should not sign in' do
          visit '/sign_in'
          expect(page).to have_selector 'h1', text: 'サインイン'
          fill_in placeholder: 'メールアドレス', with: ''
          fill_in placeholder: 'パスワード', with: ''
          click_button 'サインイン'
          expect(page).to have_selector 'h1', text: 'サインイン'
          expect(page).to have_selector '.alert'
          visit root_path
          expect(page).to_not have_selector '.alert'
        end
      end

      shared_examples_for 'no account activation' do
        it 'should not sign in' do
          visit '/sign_in'
          expect(page).to have_selector 'h1', text: 'サインイン'
          fill_in placeholder: 'メールアドレス', with: user.email
          fill_in placeholder: 'パスワード', with: user.password
          click_button 'サインイン'
          expect(page).to have_selector 'h1', text: 'WorkerBook'
          expect(page).to have_selector '.alert'
        end
      end

      context 'worker' do
        it_behaves_like 'no account activation' do
          let(:user) { create :worker, activated: false, activated_at: nil }
        end
      end

      context 'client' do
        it_behaves_like 'no account activation' do
          let(:client) { create :client }
          let(:user) { create :client_user, client: client, activated: false, activated_at: nil }
        end
      end
    end
  end
end
