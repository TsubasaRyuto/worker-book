# == Schema Information
#
# Table name: client_profiles
#
#  id             :integer          not null, primary key
#  corporate_site :string(255)      not null
#  logo           :string(255)      not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
# Indexes
#
#  index_client_profiles_on_id  (id) UNIQUE
#

class ClientProfilesController < ApplicationController
  before_action :signed_in_client, :correct_client
  def new
    @client_profile = @client.build_profile
  end

  def edit
    @client_profile = @client.profile
  end

  def create
    @client_profile = @client.build_profile(profile_params)
    if @client_profile.save
      flash[:success] = I18n.t('views.common.info.success.create_profile')
      redirect_to client_url(username: @client.username)
    else
      render :new
    end
  end

  def update
    @client_profile = @client.profile
    if @client_profile.update_attributes(profile_params)
      flash[:success] = I18n.t('views.common.info.success.update_profile')
      redirect_to client_url(username: @client.username)
    else
      render :edit
    end
  end

  private

  def profile_params
    params.require(:client_profile).permit(:corporate_site, :logo)
  end

  def signed_in_client
    unless signed_in?
      store_location
      flash[:danger] = I18n.t('views.common.info.danger.not_signed_in')
      redirect_to sign_in_url
    end
  end

  def correct_client
    @client = Client.find_by(username: params[:client_username])
    redirect_to root_url unless current_user?(@client)
  end
end
