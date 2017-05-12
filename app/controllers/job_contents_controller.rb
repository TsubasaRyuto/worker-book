# == Schema Information
#
# Table name: job_contents
#
#  id          :integer          not null, primary key
#  client_id   :integer          not null
#  title       :string(255)      not null
#  content     :text(65535)      not null
#  note        :text(65535)      not null
#  start_date  :datetime         not null
#  finish_date :datetime         not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_job_contents_on_client_id  (client_id)
#

class JobContentsController < ApplicationController
  before_action :signed_in_client
  before_action :correct_client

  def new
    @job_content = @client.job_contents.build
  end

  def show; end
  def edit; end

  def create
    @job_content = @client.job_contents.build(job_content_params)
    if @job_content.save
      flash[:success] = I18n.t('views.job_content.success.create_job_content')
      redirect_to client_path(clientname: @client.clientname)
    else
      set_job_content_skill_list_to_gon
      render :new
    end
  end

  def update; end
  def destroy; end

  private

  def job_content_params
    params.require(:job_content).permit(:title, :content, :skill_list, :note, :start_date, :finish_date)
  end

  def signed_in_client
    unless signed_in?
      store_location
      flash[:danger] = I18n.t('views.common.info.danger.not_signed_in')
      redirect_to sign_in_url
    end
  end

  def correct_client
    @client = Client.find_by(clientname: params[:client_clientname])
    @client_users = @client.client_users
    redirect_to root_url unless current_client_user?(@client_users)
  end

  def set_job_content_skill_list_to_gon
    gon.job_content_skills = @job_content.skill_list
  end
end
