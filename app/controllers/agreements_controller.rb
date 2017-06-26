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

class AgreementsController < ApplicationController
  before_action :prohibition
  before_action :signed_in_worker
  before_action :correct_worker

  def create
    @job_content = JobContent.find(params[:job_id])
    @worker = Worker.find_by(username: params[:worker_username])
    @client = Client.find_by(clientname: params[:client_clientname])
    if @worker && @worker.authenticate(params[:password])
      @agreement = @worker.agreements.build(job_content_id: @job_content.id, active: true, activated_at: Time.zone.now)
      @agreement.save!
      @client.client_users.each { |user| user.send_request_agreement_email(@worker, @job_content) }
      redirect_to worker_url(username: @worker.username), flash: { success: I18n.t('views.common.info.success.agreement') }
    else
      flash[:danger] = I18n.t('views.common.info.danger.invalid_password')
      redirect_back(fallback_location: root_url)
    end
  end

  def refusal
    @job_content = JobContent.find(params[:job_id])
    @worker = Worker.find_by(username: params[:worker_username])
    @client = Client.find_by(clientname: params[:client_clientname])
    if @worker && @worker.authenticate(params[:password])
      @job_request = (@worker.job_requests & @job_content.job_requests).first
      @job_request.destroy
      @client.client_users.each { |user| user.send_request_refusal_email(@worker, @job_content) }
      redirect_to worker_url(username: @worker.username), flash: { success: I18n.t('views.common.info.success.refusal') }
    else
      flash[:danger] = I18n.t('views.common.info.danger.invalid_password')
      redirect_back(fallback_location: root_url)
    end
  end

  private

  def prohibition
    redirect_to errors_error_404_url
  end

  def signed_in_worker
    unless signed_in?
      store_location
      redirect_to sign_in_url, flash: { danger: I18n.t('views.common.info.danger.not_signed_in') }
    end
  end

  def correct_worker
    @worker = Worker.find_by(username: params[:worker_username])
    redirect_to root_url unless current_user?(@worker)
  end
end
