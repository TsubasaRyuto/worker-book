class PasswordResetsController < ApplicationController
  before_action :find_worker, only: [:edit, :update]
  before_action :valid_worker, only: [:edit, :update]

  def new; end

  def edit; end

  def create
    @worker = Worker.find_by(email: params[:password_reset][:email].downcase)
    if @worker
      @worker.create_reset_digest
      @worker.send_password_reset_email(WorkerMailer)
      flash[:info] = I18n.t('views.common.info.success.send_apss_reset_email')
      redirect_to root_url
    else
      flash.now[:danger] = I18n.t('views.common.info.danger.not_found_email')
      render :new
    end
  end

  def update
    if params[:worker][:password].empty?
      @worker.errors.add(:password, 'は必須項目です')
      render :edit
    elsif @worker.update_attributes(worker_params)
      sign_in @worker
      flash[:success] = I18n.t('views.common.info.success.pass_reseted')
      redirect_to worker_url(username: @worker.username)
    else
      render :edit
    end
  end

  private

  def worker_params
    params.require(:worker).permit(:password, :password_confirmation)
  end

  def find_worker
    @worker = Worker.find_by(email: params[:email])
  end

  def valid_worker
    unless @worker && @worker.activated? && @worker.authenticated?(:reset, params[:id])
      redirect_to root_url
    end
  end

  def checkbox_expireation
    if @worker.password_reset_expired?
      flash[:danger] = I18n.t('views.common.info.danger.expired_link')
      redirect_to new_password_reset_url
    end
  end
end
