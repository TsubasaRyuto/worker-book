# == Schema Information
#
# Table name: workers
#
#  id                :integer          not null, primary key
#  last_name         :string(255)      not null
#  first_name        :string(255)      not null
#  username          :string(255)      not null
#  email             :string(255)      not null
#  password_digest   :string(255)      not null
#  remember_digest   :string(255)
#  activation_digest :string(255)
#  activated         :boolean          default(FALSE), not null
#  activated_at      :datetime
#  reset_digest      :string(255)
#  reset_sent_at     :datetime
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#

class WorkersController < ApplicationController
  before_action :signed_in_worker, only: [:edit, :update, :retire, :destroy]
  before_action :correct_worker, only: [:edit, :update, :retire, :destroy]

  def index
    @workers = Worker.page(params[:page]).per(10)
  end

  def show
    @worker = Worker.find_by(username: params[:username])
    raise ActiveRecord::RecordNotFound if @worker.blank? || @worker.profile.blank?
  end

  def new
    @worker = Worker.new
  end

  def edit
    @worker = Worker.find_by(username: params[:username])
  end

  def retire
    @worker = Worker.find_by(username: params[:username])
  end

  def create
    @worker = Worker.new(worker_params)
    if @worker.save
      @worker.send_activation_email
      session[:verify_email] = true
      redirect_to worker_verify_email_url
    else
      render :new
    end
  end

  def update
    @worker = Worker.find_by(username: params[:username])
    if @worker.update_attributes(update_params)
      # @worker.send_update_email
      flash[:success] = I18n.t('views.common.info.success.update_account')
      redirect_to worker_url(username: @worker.username)
    else
      render :edit
    end
  end

  def destroy
    @worker = Worker.find_by(username: params[:username])
    if @worker && @worker.authenticate(params[:password])
      @worker.destroy
      session.delete(:user_id)
      flash[:success] = I18n.t('views.common.info.success.delete_account')
      redirect_to root_url
    else
      flash[:warning] = I18n.t('views.common.info.danger.invalid_password')
      render :retire
    end
  end

  def activate
    worker = Worker.find_by(email: params[:email])
    raise ActiveRecord::RecordNotFound if worker.blank?
    if worker && !worker.activated? && worker.authenticated?(:activation, params[:token])
      worker.activate
      sign_in worker
      flash[:success] = I18n.t('views.common.info.success.sign_up_completion')
      redirect_to worker_create_profile_url(worker_username: worker.username)
    else
      flash[:danger] = I18n.t('views.common.info.danger.sign_up_failed')
      redirect_to root_url
    end
  end

  private

  def worker_params
    params.require(:worker).permit(:last_name, :first_name, :username, :email, :password, :password_confirmation)
  end

  def update_params
    params.require(:worker).permit(:username, :email)
  end

  def signed_in_worker
    unless signed_in?
      store_location
      flash[:danger] = I18n.t('views.common.info.danger.not_signed_in')
      redirect_to sign_in_url
    end
  end

  def correct_worker
    @worker = Worker.find_by(username: params[:username])
    redirect_to root_url unless current_user?(@worker)
  end
end
