class PasswordResetsController < ApplicationController
  before_action :find_user, only: [:edit, :update]
  before_action :valid_user, only: [:edit, :update]

  def new; end

  def edit; end

  def create
    @user = password_reset_user
    if @user
      @user.create_reset_digest
      @user.send_password_reset_email
      flash[:info] = I18n.t('views.common.info.success.send_apss_reset_email')
      redirect_to root_url
    else
      flash.now[:danger] = I18n.t('views.common.info.danger.not_found_email')
      render :new
    end
  end

  def update
    if params[:worker] && params[:worker][:password].empty? || params[:client] && params[:client][:password].empty?
      @user.errors.add(:password, 'は必須項目です')
      render :edit
    elsif @user.update_attributes(user_params)
      sign_in @user
      flash[:success] = I18n.t('views.common.info.success.pass_reseted')
      redirect_to worker_url(username: @user.username) if params[:worker]
      redirect_to client_url(username: @user.username) if params[:client]
    else
      render :edit
    end
  end

  private

  def user_params
    if params[:worker].present?
      params.require(:worker).permit(:password, :password_confirmation)
    elsif params[:client].present?
      params.require(:client).permit(:password, :password_confirmation)
    end
  end

  def find_user
    @user = Worker.find_by(email: params[:email]) || Client.find_by(email: params[:email])
  end

  def valid_user
    unless @user && @user.activated? && @user.authenticated?(:reset, params[:id])
      redirect_to root_url
    end
  end

  def password_reset_user
    Worker.find_by(email: params[:password_reset][:email].downcase) || Client.find_by(email: params[:password_reset][:email].downcase)
  end
end
