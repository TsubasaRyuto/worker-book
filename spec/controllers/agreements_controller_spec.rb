# == Schema Information
#
# Table name: agreements
#
#  id             :integer          not null, primary key
#  worker_id      :integer          not null
#  job_content_id :integer          not null
#  active         :boolean          default(TRUE), not null
#  activated_at   :datetime
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
# Indexes
#
#  index_agreements_on_job_content_id  (job_content_id)
#  index_agreements_on_worker_id       (worker_id)
#

require 'rails_helper'

RSpec.describe AgreementsController, type: :controller do
  let(:worker) { create :worker }
  let(:client) { create :client }
  let(:client_user) { create :client_user, client: client }
  let(:job_content) { create :job_content, client: client }
  let(:job_request) { create :job_request, job_content: job_content, worker: worker }
  let(:agreement) { worker.agreements.new(job_content_id: job_content.id, active: true, activated_at: Time.zone.now) }

  before do
    Timecop.travel(Date.new(2017, 01, 01)) do
      job_content
    end
    ApplicationMailer.deliveries.clear
    client_user
    job_request
  end

  context 'post ceate' do
    context 'success' do
      before do
        sign_in_as(worker)
      end
      it 'should agreement' do
        expect do
          post :create, params: { worker_username: worker.username, client_clientname: client.clientname, job_id: job_content.id, password: worker.password }
        end.to change { Agreement.count }.by(1)
        expect(response).to redirect_to worker_url(username: worker.username)
        expect(ActionMailer::Base.deliveries.size).to eq(1)
      end
    end

    context 'failed' do
      context 'invalid password' do
        before do
          sign_in_as(worker)
        end
        it 'should agreement' do
          request.env['HTTP_REFERER'] = client_confirmation_request_job_url(client_clientname: client.clientname, worker_username: worker.username, id: job_content.id)
          expect do
            post :create, params: { worker_username: worker.username, client_clientname: client.clientname, job_id: job_content.id, password: 'invalidpassword' }
          end.to change { Agreement.count }.by(0)
          expect(response).to redirect_to client_confirmation_request_job_url(client_clientname: client.clientname, worker_username: worker.username, id: job_content.id)
        end
      end

      context 'not signed in' do
        before do
          post :create, params: { worker_username: worker.username, client_clientname: client.clientname, job_id: job_content.id, password: worker.password }
        end
        it { expect(response).to redirect_to sign_in_url }
      end
    end
  end

  context 'post refusal' do
    context 'success' do
      before do
        sign_in_as(worker)
      end
      it 'should agreement' do
        expect do
          post :refusal, params: { worker_username: worker.username, client_clientname: client.clientname, job_id: job_content.id, password: worker.password }
        end.to change { JobRequest.count }.by(-1)
        expect(response).to redirect_to worker_url(username: worker.username)
        expect(ActionMailer::Base.deliveries.size).to eq(1)
      end
    end

    context 'failed' do
      context 'invalid password' do
        before do
          sign_in_as(worker)
        end
        it 'should agreement' do
          request.env['HTTP_REFERER'] = client_confirmation_request_job_url(client_clientname: client.clientname, worker_username: worker.username, id: job_content.id)
          expect do
            post :refusal, params: { worker_username: worker.username, client_clientname: client.clientname, job_id: job_content.id, password: 'invalid_password' }
          end.to change { JobRequest.count }.by(0)
          expect(response).to redirect_to client_confirmation_request_job_url(client_clientname: client.clientname, worker_username: worker.username, id: job_content.id)
        end
      end

      context 'not signed in' do
        before do
          post :refusal, params: { worker_username: worker.username, client_clientname: client.clientname, job_id: job_content.id, password: worker.password }
        end
        it { expect(response).to redirect_to sign_in_url }
      end
    end
  end
end
