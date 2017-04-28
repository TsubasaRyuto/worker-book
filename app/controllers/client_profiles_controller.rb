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
  def new
    @client = current_user
    if @client && @client.activated?
      @client_profile = @client.build_profile
    else
      redirect_to root_url
    end
  end

  def edit; end

  def create
    @client = current_user
    @client_profile = @client.build_profile(profile_params)
    if @client_profile.save
      flash[:success] = 'プロフィールを作成しました'
      redirect_to client_url(username: @client.username)
    else
      render :new
    end
  end

  def update; end

  private

  def profile_params
    params.require(:client_profile).permit(:corporate_site, :logo)
  end
end
