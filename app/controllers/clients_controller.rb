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
  def show
    @client = Client.find_by(username: params[:username])
    raise ActiveRecord::RecordNotFound if @client.blank? || @client.profile.blank?
  end

  def new
    @client = Client.new
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
end
