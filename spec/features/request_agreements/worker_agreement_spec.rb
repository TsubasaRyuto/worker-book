require 'rails_helper'

RSpec.feature 'RequestAgreements:WorkerAgreement', type: :feature, js: true do
  let(:worker) { create :worker }
  let(:worker_profile) { create :worker_profile, worker: worker}
  let(:client) { create :client }
  let(:client_user) { create :client_user, client: client }
  let(:job_content) { create :job_content, client: client }
  context 'client request job to worker' do
    before do
      ApplicationMailer.deliveries.clear
      sign_on_as(client_user)
      worker
      worker_profile
      Timecop.travel(Date.new(2017,01,01)) do
        job_content
      end
    end
    context 'successfull' do
      it 'should agreement request job' do
        visit client_confirmation_request_job_path(client_clientname: client.clientname, worker_username: worker.username, id: job_content.id)
        expect(page).to have_selector 'h1', text: '依頼ワーカー'
        expect(page).to have_selector 'h2', text: "#{worker.last_name} #{worker.first_name}"
        expect(page).to have_selector 'h1', text: '発注内容'
        expect(page).to have_selector 'p', text: "#{job_content.title}"
        page.find('#send-request').click
        page.execute_script("$('#order-request').modal('show')")
        expect(page).to have_selector 'h4', text: '本人確認'
        fill_in id: 'password', with: client_user.password
        click_on '送信'
        expect(page).to have_selector 'h2', text: "#{client.name}"
        url = URI.parse(current_url)
        expect(url.path).to eq(client_path(clientname: client.clientname))
        click_link 'Sign out'
        sign_on_as(worker)
        mail = ApplicationMailer.deliveries.last
        mail_body = mail.body.encoded
        activation_token = mail_body.split('/')[8].split('?')[0]
        visit worker_order_confirms_path(token: activation_token, email: worker.email, worker_username: worker.username, client_clientname: client.clientname, job_id: job_content.id)
        expect(page).to have_selector 'h1', text: 'My profile'
        expect(page).to have_selector 'h2', text: "#{worker.last_name} #{worker.first_name}"
        expect(page).to have_selector 'h1', text: 'Order content'
        expect(page).to have_selector 'p', text: "#{job_content.title}"
        # キャンセルボタンテスト
        page.find('#send-agreement').click
        page.execute_script("$('#agreement-password-confirm').modal('show')")
        expect(page).to have_selector 'h4', text: '本人確認'
        click_on 'キャンセル'
        expect(page).to have_selector 'h1', text: 'My profile'
        expect(page).to have_selector 'h1', text: 'Order content'

        # 受諾ボタンテスト
        page.find('#send-agreement').click
        page.execute_script("$('#agreement-password-confirm').modal('show')")
        expect(page).to have_selector 'h4', text: '本人確認'
        fill_in id: 'password', with: worker.password
        click_on '受諾'
        expect(page).to have_selector 'h2', text: "#{worker.last_name} #{worker.first_name}"
        expect(page).to have_selector '.alert'
        url = URI.parse(current_url)
        expect(url.path).to eq worker_path(username: worker.username)
      end
    end

    context 'failed' do
      it 'should not agreement' do
        visit client_confirmation_request_job_path(client_clientname: client.clientname, worker_username: worker.username, id: job_content.id)
        expect(page).to have_selector 'h1', text: '依頼ワーカー'
        expect(page).to have_selector 'h2', text: "#{worker.last_name} #{worker.first_name}"
        expect(page).to have_selector 'h1', text: '発注内容'
        expect(page).to have_selector 'p', text: "#{job_content.title}"
        page.find('#send-request').click
        page.execute_script("$('#order-request').modal('show')")
        expect(page).to have_selector 'h4', text: '本人確認'
        fill_in id: 'password', with: client_user.password
        click_on '送信'
        expect(page).to have_selector 'h2', text: "#{client.name}"
        url = URI.parse(current_url)
        expect(url.path).to eq client_path(clientname: client.clientname)
        click_link 'Sign out'
        sign_on_as(worker)
        mail = ApplicationMailer.deliveries.last
        mail_body = mail.body.encoded
        activation_token = mail_body.split('/')[8].split('?')[0]
        visit worker_order_confirms_path(token: activation_token, email: worker.email, worker_username: worker.username, client_clientname: client.clientname, job_id: job_content.id)
        expect(page).to have_selector 'h1', text: 'My profile'
        expect(page).to have_selector 'h2', text: "#{worker.last_name} #{worker.first_name}"
        expect(page).to have_selector 'h1', text: 'Order content'
        expect(page).to have_selector 'p', text: "#{job_content.title}"
        page.find('#send-agreement').click
        page.execute_script("$('#agreement-password-confirm').modal('show')")
        expect(page).to have_selector 'h4', text: '本人確認'
        fill_in id: 'password', with: 'invalid_password'
        click_on '受諾'
        expect(page).to have_selector 'h1', text: 'My profile'
        expect(page).to have_selector 'h1', text: 'Order content'
        expect(page).to have_selector '.alert'
        url = URI.parse(current_url)
        expect("#{url.path}?#{url.query}").to eq worker_order_confirms_path(token: activation_token, email: worker.email, worker_username: worker.username, client_clientname: client.clientname, job_id: job_content.id)
      end
    end
  end
end
