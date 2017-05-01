require 'rails_helper'

RSpec.feature 'Workers:UpdateProfile', type: :feature, js: true do
  context 'workers update profile' do
    let(:worker) { create :worker }
    let(:worker_profile) { create :worker_profile, worker: worker }
    before do
      sign_on_as(worker)
      worker_profile
    end
    context 'successfull' do
      it 'should create profile by worker' do
        visit worker_settings_profile_path(worker_username: worker.username)
        expect(page).to have_selector 'h1', text: 'Update Profile'
        page.find('.lever', text: 'Web Developer').click
        page.find('.lever', text: 'Other').click
        choose id: 'worker_profile_availability_full'
        fill_in id: 'worker_profile_past_performance1', with: 'http://example1.com'
        fill_in id: 'worker_profile_past_performance2', with: 'http://example2.com'
        fill_in id: 'input-price', with: '40000'
        fill_in id: 'worker_profile_appeal_note', with: 'test' * 101
        attach_file('worker_profile_picture', 'spec/fixtures/images/lobo.png')
        select '北海道', from: 'worker_profile_location'
        fill_in id: 'worker_profile_employment_history1', with: 'Example Inc'
        fill_in id: 'worker_profile_employment_history2', with: 'Example.com Inc'
        click_button 'Save changes'
        expect(page).to have_selector 'div.alert-success'
        expect(page).to have_selector 'h2', text: "#{worker.last_name} #{worker.first_name}"
        worker_profile.reload
        expect(worker_profile.type_web_developer).to be_falsey
      end
    end
    context 'failed' do
      it 'should not create profile by worker' do
        visit worker_settings_profile_path(worker_username: worker.username)
        page.find('.lever', text: 'Mobile Developer').click
        page.find('.lever', text: 'Game Developer').click
        page.find('.lever', text: 'Web Developer').click
        expect(page).to have_selector 'h1', text: 'Update Profile'
        fill_autocomplete('ui-autocomplete-input', with: 'javas', select: 'JavaScript')
        expect(page).to have_selector 'span.tagit-label', text: 'JavaScript'
        fill_autocomplete('ui-autocomplete-input', with: 'jque', select: 'jQuery')
        expect(page).to have_selector 'span.tagit-label', text: 'jQuery'
        fill_autocomplete('ui-autocomplete-input', with: 'php', select: 'PHP')
        expect(page).to have_selector 'span.tagit-label', text: 'PHP'
        fill_autocomplete('ui-autocomplete-input', with: 'py', select: 'Python')
        expect(page).to have_selector 'span.tagit-label', text: 'Python'
        fill_autocomplete('ui-autocomplete-input', with: 'htm', select: 'HTML')
        expect(page).to have_selector 'span.tagit-label', text: 'HTML'
        choose id: 'worker_profile_availability_limited'
        fill_in id: 'worker_profile_past_performance1', with: 'http://example1.com'
        fill_in id: 'input-price', with: '40000'
        fill_in id: 'worker_profile_appeal_note', with: 'test' * 101
        attach_file('worker_profile_picture', 'spec/fixtures/images/lobo.png')
        select '北海道', from: 'worker_profile_location'
        fill_in id: 'worker_profile_employment_history1', with: 'Example Inc'
        click_button 'Save changes'
        expect(page).to have_selector 'h1', text: 'Update Profile'
      end
    end
  end
end
