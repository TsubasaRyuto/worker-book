require 'rails_helper'

RSpec.feature 'RequestAgreements:ClientRequest', type: :feature, js: true do
  let(:worker) { create :worker }
  let(:worker_profile) { create :worker_profile, worker: worker }
  let(:client) { create :client }
  let(:client_user) { create :client_user, client: client }
  let(:job_content) { create :job_content, client: client }
  context 'client request job to worker' do
    before do
      ApplicationMailer.deliveries.clear
      worker
      worker_profile
      Timecop.travel(Date.new(2017, 01, 01)) do
        job_content
      end
    end
    context 'successfull' do
      it 'should select worker and request job and agreement' do
        sign_on_as(client_user)
        visit workers_path
        expect(page).to have_selector 'h1', text: 'Worker List'
        expect(page).to have_selector 'h2', text: "#{worker.last_name} #{worker.first_name}"
        click_link href: worker_path(username: worker.username)
        expect(page).to have_selector 'h2', text: 'Developer Types & Skills'
        expect(page).to have_selector 'h2', text: '仕事に対する思い、スキルアピール'
        click_button '発注選択'
        expect(page).to have_selector 'h1', text: '依頼ワーカー'
        expect(page).to have_selector 'h1', text: '発注内容一覧'
        click_link job_content.title.to_s
        expect(page).to have_selector 'h1', text: '依頼ワーカー'
        expect(page).to have_selector 'h2', text: "#{worker.last_name} #{worker.first_name}"
        expect(page).to have_selector 'h1', text: '発注内容'
        expect(page).to have_selector 'p', text: job_content.title.to_s
        # キャンセルボタンテスト
        page.find('#send-request').click
        page.execute_script("$('#order-request').modal('show')")
        expect(page).to have_selector 'h4', text: '本人確認'
        click_on 'キャンセル'
        expect(page).to have_selector 'h1', text: '依頼ワーカー'
        expect(page).to have_selector 'h1', text: '発注内容'

        # 送信ボタンテスト
        page.find('#send-request').click
        page.execute_script("$('#order-request').modal('show')")
        expect(page).to have_selector 'h4', text: '本人確認'
        fill_in id: 'password', with: client_user.password
        click_on '送信'
        expect(page).to have_selector 'h2', text: client.name.to_s
        url = URI.parse(current_url)
        expect(url.path).to eq(client_path(clientname: client.clientname))
      end
    end

    context 'failed' do
      it 'should not request job' do
        sign_on_as(client_user)
        visit workers_path
        expect(page).to have_selector 'h1', text: 'Worker List'
        expect(page).to have_selector 'h2', text: "#{worker.last_name} #{worker.first_name}"
        click_link href: worker_path(username: worker.username)
        expect(page).to have_selector 'h2', text: 'Developer Types & Skills'
        expect(page).to have_selector 'h2', text: '仕事に対する思い、スキルアピール'
        click_button '発注選択'
        expect(page).to have_selector 'h1', text: '依頼ワーカー'
        expect(page).to have_selector 'h1', text: '発注内容一覧'
        click_link job_content.title.to_s
        expect(page).to have_selector 'h1', text: '依頼ワーカー'
        expect(page).to have_selector 'h2', text: "#{worker.last_name} #{worker.first_name}"
        expect(page).to have_selector 'h1', text: '発注内容'
        expect(page).to have_selector 'p', text: job_content.title.to_s
        # キャンセルボタンテスト
        page.find('#send-request').click
        page.execute_script("$('#order-request').modal('show')")
        expect(page).to have_selector 'h4', text: '本人確認'
        click_on 'キャンセル'
        expect(page).to have_selector 'h1', text: '依頼ワーカー'
        expect(page).to have_selector 'h1', text: '発注内容'

        # 送信ボタンテスト
        page.find('#send-request').click
        page.execute_script("$('#order-request').modal('show')")
        expect(page).to have_selector 'h4', text: '本人確認'
        fill_in id: 'password', with: 'invalid_password'
        click_on '送信'
        expect(page).to have_selector 'h1', text: '依頼ワーカー'
        expect(page).to have_selector 'h1', text: '発注内容'
        url = URI.parse(current_url)
        expect(url.path).to eq client_confirmation_request_job_path(client_clientname: client.clientname, worker_username: worker.username, id: job_content.id)
      end
    end
  end
end
