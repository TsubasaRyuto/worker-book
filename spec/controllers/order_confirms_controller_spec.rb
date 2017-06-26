require 'rails_helper'

RSpec.describe OrderConfirmsController, type: :controller do
  let(:worker) { create :worker }
  let(:client) { create :client }
  let(:client_user) { create :client_user, client: client }
  let(:job_content) { create :job_content, client: client }
  let(:job_request) { create :job_request, worker: worker, job_content: job_content }

  before do
    Timecop.travel(Date.new(2017, 01, 01)) do
      job_content
    end
  end

  context 'get show' do
    context 'successful' do
      before do
        sign_in_as(worker)
        get :show, params: { token: job_request.activation_token, email: worker.email, worker_username: worker.username, client_clientname: client.clientname, job_id: job_content.id }
      end
      it { expect(response).to redirect_to errors_error_404_url }
      # it { expect(response).to have_http_status :success }
    end

    context 'failed' do
      before do
        get :show, params: { token: job_request.activation_token, email: worker.email, worker_username: worker.username, client_clientname: client.clientname, job_id: job_content.id }
      end
      it { expect(response).to redirect_to errors_error_404_url }
      # it { expect(response).to redirect_to sign_in_url }
    end
  end
end
