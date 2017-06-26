# == Schema Information
#
# Table name: job_requests
#
#  id                :integer          not null, primary key
#  worker_id         :integer          not null
#  job_content_id    :integer          not null
#  activation_digest :string(255)
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#
# Indexes
#
#  index_job_requests_on_job_content_id  (job_content_id)
#  index_job_requests_on_worker_id       (worker_id)
#

class JobRequestsController < ApplicationController
  before_action :signed_in_client
  before_action :correct_client_user
  def create
    @worker = Worker.find_by(username: params[:worker_username])
    @job_content = JobContent.find(params[:job_id])
    already_agreement_worker
    @client_user = current_user if current_user.client == @client
    if @client_user && @client_user.authenticate(params[:password])
      @job_request = @worker.job_requests.new(request_params)
      @job_request.save!
      @worker.send_request_email(@client, @job_content, @job_request)
      redirect_to client_url(clientname: current_user.client.clientname), flash: { success: I18n.t('job_content.request_job_content.success') }
    else
      flash[:danger] = I18n.t('views.common.info.danger.invalid_password')
      redirect_back(fallback_location: root_url)
    end
  end

  private

  def request_params
    { job_content_id: @job_content.id }
  end

  def signed_in_client
    unless signed_in?
      store_location
      redirect_to sign_in_url, flash: { danger: I18n.t('views.common.info.danger.not_signed_in') }
    end
  end

  def correct_client_user
    @client = Client.find_by(clientname: params[:client_clientname])
    @client_users = @client.client_users
    redirect_to root_url unless current_client_user?(@client_users)
  end

  def already_agreement_worker
    if @worker.agreements.where(job_content_id: @job_content.id).present?
      redirect_to workers_url, flash: { danger: "#{@job_content.title}はすでに#{@worker}さんと契約済みです" }
    end
  end
end
