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
      it 'should not sign up' do
        visit '/worker/sign_up'
        fill_in placeholder: 'Last Name', with: 'Foo'
        fill_in placeholder: 'First Name', with: 'Bar'
        fill_in placeholder: 'Username', with: 'foobar'
        fill_in placeholder: 'Email', with: 'foobar@example.com'
        fill_in placeholder: 'Password', with: 'foobar123'
        fill_in placeholder: 'Confirmation', with: 'foobar123'
        expect { click_button 'Create my account' }.to change { Worker.count }.by(1)
        expect(ApplicationMailer.deliveries.size).to eq 1
        worker = Worker.last
        expect(worker.activated?).to be_falsey
      end
    end
  end
end
