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
