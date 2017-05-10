# == Schema Information
#
# Table name: client_users
#
#  id                :integer          not null, primary key
#  client_id         :integer          not null
#  last_name         :string(255)      not null
#  first_name        :string(255)      not null
#  username          :string(255)      not null
#  email             :string(255)      not null
#  user_type         :integer          default("admin")
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
# Indexes
#
#  index_client_users_on_client_id  (client_id)
#

class ClientUsersController < ApplicationController
  before_action :signed_in_client, only: [:edit, :update, :retire, :destroy]
  before_action :correct_client, only: [:edit, :update, :retire, :destroy]

  def show
    @client_user = ClientUser.find_by(username: params[:username])
    raise ActiveRecord::RecordNotFound if @client_user.blank?
  end

  def edit
    @client_user = ClientUser.find_by(username: params[:username])
  end

  def retire
    @client = Client.find_by(clientname: params[:client_clientname])
    @client_user = ClientUser.find_by(username: params[:username])
  end

  def update
    @client_user = ClientUser.find_by(username: params[:username])
    if @client_user.update_attributes(update_params)
      # @client_user.send_update_email
      flash[:success] = I18n.t('views.common.info.success.update_account')
      redirect_to client_url(clientname: @client_user.client.clientname)
    else
      render :edit
    end
  end

  def destroy
    @client = Client.find_by(clientname: params[:client_clientname])
    @client_user = ClientUser.find_by(username: params[:username])
    if @client_user && @client_user.authenticate(params[:password])
      @client.delete
      @client_user.delete
      session.delete(:user_id)
      flash[:success] = I18n.t('views.common.info.success.delete_account')
      redirect_to root_url
    else
      flash[:warning] = I18n.t('views.common.info.danger.invalid_password')
      render :retire
    end
  end

  def activate
    client_user = ClientUser.find_by(email: params[:email])
    raise ActiveRecord::RecordNotFound if client_user.blank?
    if client_user && !client_user.activated? && client_user.authenticated?(:activation, params[:token])
      client_user.activate
      sign_in client_user
      flash[:success] = I18n.t('views.common.info.success.sign_up_completion')
      redirect_to client_url(clientname: client_user.client.clientname)
    else
      flash[:danger] = I18n.t('views.common.info.danger.sign_up_failed')
      redirect_to root_url
    end
  end

  private

  def update_params
    params.require(:client_user).permit(:last_name, :first_name, :username, :email)
  end

  def signed_in_client
    unless signed_in?
      store_location
      flash[:danger] = I18n.t('views.common.info.danger.not_signed_in')
      redirect_to sign_in_url
    end
  end

  def correct_client
    @client_user = ClientUser.find_by(username: params[:username])
    redirect_to root_url unless current_user?(@client_user)
  end
end
