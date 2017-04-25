require 'rails_helper'

RSpec.feature 'Sessions::SignIn', type: :feature do
  context 'sign in' do
    context 'successfull' do
      shared_examples_for 'valid information but not create profile' do
        it 'should sign in on remember_me' do
          visit '/sign_in'
          expect(page).to have_selector 'h1', text: 'Sign In'
          fill_in placeholder: 'Email', with: user.email
          fill_in placeholder: 'Password', with: user.password
          click_button 'Sign In'
          expect(signed_on?(user)).to be_truthy
          expect(page).to have_selector 'h1', text: 'Create Profile'
          if user_type(user) == 'worker'
            expect(page).to have_link user.username.to_s
          else
            expect(page).to have_link user.company_name.to_s
          end
          expect(page).to have_link 'Sign out', href: '/sign_out'
          expect(page).to have_link 'Delete Account', href: "/#{user_type(user)}/#{user.username}/retire"
        end
      end

      shared_examples_for 'valid information and created profile' do
        before do
          profile
        end
        it 'should sign in on remember_me' do
          visit '/sign_in'
          expect(page).to have_selector 'h1', text: 'Sign In'
          fill_in placeholder: 'Email', with: user.email
          fill_in placeholder: 'Password', with: user.password
          click_button 'Sign In'
          expect(signed_on?(user)).to be_truthy
          expect(page).to have_selector 'h2', text: "#{user.last_name} #{user.first_name}"
          if user_type(user) == 'worker'
            expect(page).to have_link user.username.to_s
          else
            expect(page).to have_link user.company_name.to_s
          end
          expect(page).to have_link 'Sign out', href: '/sign_out'
          expect(page).to have_link 'Settings', href: "/#{user_type(user)}/#{user.username}/settings/profile"
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
        it_behaves_like 'valid information but not create profile' do
          let(:user) { create :client }
        end

        it_behaves_like 'valid information and created profile' do
          let(:user) { create :client }
          let(:profile) { create :client_profile, client: user }
        end

        it_behaves_like 'with not remember_me' do
          let(:user) { create :client }
        end

        it_behaves_like 'with remember_me' do
          let(:user) { create :client }
        end
      end
    end

    context 'failed' do
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

      shared_examples_for 'no account activation' do
        it 'should not sign in' do
          visit '/sign_in'
          expect(page).to have_selector 'h1', text: 'Sign In'
          fill_in placeholder: 'Email', with: user.email
          fill_in placeholder: 'Password', with: user.password
          click_button 'Sign In'
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
          let(:user) { create :client, activated: false, activated_at: nil }
        end
      end
    end
  end
end
