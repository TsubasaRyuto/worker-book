# == Schema Information
#
# Table name: clients
#
#  id                :integer          not null, primary key
#  last_name         :string(255)      not null
#  first_name        :string(255)      not null
#  username          :string(255)      not null
#  company_name      :string(255)      not null
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

class ClientsController < ApplicationController
  before_action :signed_in_client, only: [:edit, :update, :retire, :destroy]
  before_action :correct_client, only: [:edit, :update, :retire, :destroy]

  def show
    @client = Client.find_by(username: params[:username])
    raise ActiveRecord::RecordNotFound if @client.blank? || @client.profile.blank?
  end

  def new
    @client = Client.new
  end

  def edit
    @client = Client.find_by(username: params[:username])
  end

  def retire
    @client = Client.find_by(username: params[:username])
  end

  def create
    @client = Client.new(client_params)
    if @client.save
      @client.send_activation_email
      session[:verify_email] = true
      redirect_to client_verify_email_url
    else
      render :new
    end
  end

  def update
    @client = Client.find_by(username: params[:username])
    if @client.update_attributes(update_params)
      # @client.send_update_email
      flash[:success] = I18n.t('views.common.info.success.update_account')
      redirect_to client_url(username: @client.username)
    else
      render :edit
    end
  end

  def destroy
    @client = Client.find_by(username: params[:username])
    if @client && @client.authenticate(params[:password])
      @client.destroy
      session.delete(:client_id)
      flash[:success] = I18n.t('views.common.info.success.delete_account')
      redirect_to root_url
    else
      flash[:warning] = I18n.t('views.common.info.danger.invalid_password')
      render :retire
    end
  end

  def activate
    client = Client.find_by(email: params[:email])
    raise ActiveRecord::RecordNotFound if client.blank?
    if client && !client.activated? && client.authenticated?(:activation, params[:token])
      client.activate
      sign_in client
      flash[:success] = I18n.t('views.common.info.success.sign_up_completion')
      redirect_to client_create_profile_url(client_username: client.username)
    else
      flash[:danger] = I18n.t('views.common.info.danger.sign_up_failed')
      redirect_to root_url
    end
  end

  private

  def client_params
    params.require(:client).permit(:last_name, :first_name, :username, :company_name, :email, :password, :password_confirmation)
  end

  def update_params
    params.require(:client).permit(:last_name, :first_name, :username, :company_name, :email)
  end

  def signed_in_client
    unless signed_in?
      store_location
      flash[:danger] = I18n.t('views.common.info.danger.not_signed_in')
      redirect_to sign_in_url
    end
  end

  def correct_client
    @client = Client.find_by(username: params[:username])
    redirect_to root_url unless current_user?(@client)
  end
end
