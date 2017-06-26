require 'rails_helper'

RSpec.feature 'Clients:UpdateJobContent', type: :feature, js: true do
  context 'update job content' do
    let(:client) { create :client }
    let(:client_user) { create :client_user, client: client }
    let(:job_content) { create :job_content, client: client }

    before do
      sign_on_as(client_user)
      Timecop.travel(Date.new(2016, 01, 01))
    end
    context 'successfull' do
      it 'should update job content' do
        visit edit_client_job_path(client_clientname: client.clientname, id: job_content.id)
        expect(page).to have_selector 'h1', text: '発注内容変更'
        expect(job_content.title).to eq('test title')
        fill_in placeholder: 'ex) WorkerBookのようなwebサービス開発', with: 'iosアプリケーション'
        page.find('#job_content_start_date').set('2016/02/01')
        page.find('#job_content_finish_date').set('2016/05/01')
        fill_in id: 'job_content_content', with: 'test' * 101
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
        fill_in id: 'job_content_note', with: 'test' * 101
        click_button '変更を保存'
        expect(page).to have_selector 'h2', text: client.name.to_s
        expect(page).to have_selector '.alert-success'
        job_content.reload
        expect(job_content.title).to eq('iosアプリケーション')
      end
    end

    context 'failed' do
      it 'should not update job content' do
        visit edit_client_job_path(client_clientname: client.clientname, id: job_content.id)
        expect(page).to have_selector 'h1', text: '発注内容変更'
        fill_in placeholder: 'ex) WorkerBookのようなwebサービス開発', with: ''
        page.find('#job_content_start_date').set('2016/02/01')
        page.find('#job_content_finish_date').set('2016/05/01')
        fill_in id: 'job_content_content', with: 'test' * 101
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
        fill_in id: 'job_content_note', with: 'test' * 101
        click_button '変更を保存'
        expect(page).to have_selector 'h1', text: '発注内容変更'
      end
    end
  end
end
