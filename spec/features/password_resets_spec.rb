require 'rails_helper'

RSpec.feature 'PasswordRests', type: :feature do
  shared_examples_for 'password reset spec' do
    before do
      user_profile
      ActionMailer::Base.deliveries.clear
      visit new_password_reset_path
    end

    it 'password resets' do
      expect(page).to have_selector 'h1', text: 'Forgot your password?'

      # imvalid email
      fill_in 'Email', with: ' '
      click_button 'Send an email'
      expect(page).to have_selector '.alert'
      expect(page).to have_selector 'h1', text: 'Forgot your password?'

      # valid email
      fill_in 'Email', with: user.email
      click_button 'Send an email'
      expect(ActionMailer::Base.deliveries.size).to eq 1
      expect(user.reload.reset_digest).to eq user.reset_digest
      expect(page).to have_selector '.alert'
      expect(current_path).to eq root_path

      # reset password form link
      mail = ApplicationMailer.deliveries.last
      mail_body = mail.body.encoded
      reset_token = mail_body.split('/')[5]

      # valid email
      visit edit_password_reset_path(reset_token, email: '')
      expect(current_path).to eq root_path

      # invalid user
      user.toggle!(:activated)
      visit edit_password_reset_path(reset_token, email: user.email)
      expect(current_path).to eq root_path
      user.toggle!(:activated)

      # valid email and valid token
      visit edit_password_reset_path(reset_token, email: user.email)
      expect(page).to have_selector 'h1', text: 'Reset password'
      expect(find('input[name=email]', visible: false).value).to eq user.email

      # invalid password and confirmation
      fill_in placeholder: 'Password', with: 'foobaz12'
      fill_in placeholder: 'Confirmation', with: 'barquux'
      click_button 'Reset password'
      expect(page).to have_selector 'div#error_explanation'

      # password is empty
      fill_in placeholder: 'Password', with: ''
      fill_in placeholder: 'Confirmation', with: ''
      click_button 'Reset password'
      expect(page).to have_selector 'div#error_explanation'

      # valid password and confirmation
      fill_in placeholder: 'Password', with: 'foobaz12'
      fill_in placeholder: 'Confirmation', with: 'foobaz12'
      click_button 'Reset password'
      user.reload
      expect(signed_on?(user)).to be_truthy
      expect(page).to have_selector '.alert'
      expect(current_path).to eq redirect_url
    end
  end

  context 'worker' do
    it_behaves_like 'password reset spec' do
      let(:user) { create :worker }
      let(:user_profile) { create :worker_profile, worker: user }
      let(:redirect_url) { "/worker/#{user.username}" }
    end
  end

  context 'client' do
    it_behaves_like 'password reset spec' do
      let(:user_profile) { create :client }
      let(:user) { create :client_user, client: user_profile }
      let(:redirect_url) { "/client/#{user_profile.clientname}" }
    end
  end
end
