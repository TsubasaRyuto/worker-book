# == Schema Information
#
# Table name: clients
#
#  id             :integer          not null, primary key
#  name           :string(255)      not null
#  corporate_site :string(255)      not null
#  clientname     :string(255)      not null
#  location       :string(255)      default("01"), not null
#  logo           :string(255)      not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

class ClientsController < ApplicationController
  before_action :signed_in_client, only: [:edit, :update, :show]
  before_action :correct_client, only: [:edit, :update, :show]
  def new
    @client = Client.new
    @client.client_users.build
  end

  def edit; end

  def show
    @client = Client.find_by(clientname: params[:clientname])
    @job_contents = @client.job_contents
  end

  def create
    @client = Client.new(profile_params)
    if @client.save
      @client_user = @client.client_users.last
      @client_user.send_activation_email
      session[:verify_email] = true
      redirect_to client_verify_email_url
    else
      render :new
    end
  end

  def update
    if @client.update_attributes(update_params)
      redirect_to client_url(clientname: @client.clientname), flash: { success: I18n.t('views.common.info.success.update_profile') }
    else
      render :edit
    end
  end

  private

  def profile_params
    params.require(:client).permit(:name, :corporate_site, :clientname, :location, :logo, client_users_attributes: [:last_name, :first_name, :username, :email, :password, :password_confirmation])
  end

  def update_params
    params.require(:client).permit(:name, :corporate_site, :clientname, :location, :logo)
  end

  def signed_in_client
    unless signed_in?
      store_location
      redirect_to sign_in_url, flash: { danger: I18n.t('views.common.info.danger.not_signed_in') }
    end
  end

  def correct_client
    @client = Client.find_by(clientname: params[:clientname])
    @client_users = @client.client_users
    redirect_to root_url unless current_client_user?(@client_users)
  end
end
