class OrderConfirmsController < ApplicationController
  before_action :signed_in_worker
  before_action :correct_worker
  def show
    @client = Client.find_by(clientname: params[:client_clientname])
    @job_content = JobContent.find(params[:job_id])
    @worker = Worker.find_by(username: params[:worker_username])
  end

  private

  def signed_in_worker
    unless signed_in?
      store_location
      flash[:danger] = I18n.t('views.common.info.danger.not_signed_in')
      redirect_to sign_in_url
    end
  end

  def correct_worker
    @worker = Worker.find_by(username: params[:worker_username])
    redirect_to root_url unless current_user?(@worker)
  end
end
