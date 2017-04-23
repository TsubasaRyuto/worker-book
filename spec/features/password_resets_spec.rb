require 'rails_helper'

RSpec.feature 'PasswordRests', type: :feature do
  context 'password reset spec' do
    let(:worker) { create :worker }
    let(:worker_profile) { create :worker_profile, worker: worker }
    before do
      worker_profile
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
      fill_in 'Email', with: worker.email
      click_button 'Send an email'
      expect(ActionMailer::Base.deliveries.size).to eq 1
      expect(worker.reload.reset_digest).to eq worker.reset_digest
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
      worker.toggle!(:activated)
      visit edit_password_reset_path(reset_token, email: worker.email)
      expect(current_path).to eq root_path
      worker.toggle!(:activated)

      # valid email and valid token
      visit edit_password_reset_path(reset_token, email: worker.email)
      expect(page).to have_selector 'h1', text: 'Reset password'
      expect(find('input[name=email]', visible: false).value).to eq worker.email

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
      worker.reload
      expect(signed_on?(worker)).to be_truthy
      expect(page).to have_selector '.alert'
      expect(current_path).to eq worker_path(username: worker.username)
    end
  end
end
