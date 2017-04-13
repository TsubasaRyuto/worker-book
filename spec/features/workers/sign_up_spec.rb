require 'rails_helper'

RSpec.feature 'Workers:SingUp', type: :feature do
  context 'workers sign up' do
    before do
      ApplicationMailer.deliveries.clear
    end
    context 'invalid information' do
      it 'should not sign up' do
        visit '/worker/sign_up'
        fill_in placeholder: 'Last Name', with: ''
        fill_in placeholder: 'First Name', with: ''
        fill_in placeholder: 'Username', with: 'invali+info'
        fill_in placeholder: 'Email', with: 'worker@invalid'
        fill_in placeholder: 'Password', with: 'foo'
        fill_in placeholder: 'Confirmation', with: 'bar'
        expect { click_button 'Create my account' }.to_not change { Worker.count }
        expect(page).to have_selector 'h1', 'Create Account of Freelancer'
        expect(page).to have_selector 'div#error_explanation'
        expect(page).to have_selector 'div.field_with_errors'
      end
    end

    context 'valid information' do
      it 'should sign up with account activate' do
        visit '/worker/sign_up'
        fill_in placeholder: 'Last Name', with: 'Foo'
        fill_in placeholder: 'First Name', with: 'Bar'
        fill_in placeholder: 'Username', with: 'foobar'
        fill_in placeholder: 'Email', with: 'foobar@example.com'
        fill_in placeholder: 'Password', with: 'foobar123'
        fill_in placeholder: 'Confirmation', with: 'foobar123'
        expect(page).to have_selector 'h1', 'Member registration have not ended yet.'
        expect { click_button 'Create my account' }.to change { Worker.count }.by(1)
        expect(ApplicationMailer.deliveries.size).to eq 1
        worker = Worker.last
        expect(worker.activated?).to be_falsey
        # --- not activated
        sign_on_as(worker)
        expect(signed_on?(worker)).to be_falsey
        # ---

        # --- invalid token of activate
        visit activate_worker_url('invalid token')
        expect(signed_on?(worker)).to be_falsey
        # ---
        mail = ApplicationMailer.deliveries.last
        mail_body = mail.body.encoded
        mail_body.split('\r\n').detect { |s| s.start_with?('http') }
        activation_token = mail_body.split('/')[4]

        # --- valid token but email is invalid
        visit activate_worker_url(activation_token, email: 'invalid email')
        expect(signed_on?(worker)).to be_falsey
        # ---

        # --- valid activate
        visit activate_worker_path(activation_token, email: worker.email)
        expect(worker.reload.activated?).to be_truthy
        expect(signed_on?(worker)).to be_truthy
        expect(page).to have_selector 'h1', text: "Create Profile"
      end
    end
  end
end
