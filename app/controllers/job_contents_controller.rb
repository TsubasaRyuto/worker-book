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
#  finished    :boolean          default(FALSE), not null
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

  def select_job_content
    @worker = Worker.find_by(username: params[:worker_username])
    @job_contents = @client.job_contents.all
    @active_job_contents = []
    @job_contents.each do |job_content|
      @active_job_contents.push(job_content) unless job_content.finished?
    end
  end

  def show
    @job_content = @client.job_contents.find(params[:id])
    @worker = Worker.find_by(username: params[:worker_username])
  end

  def edit
    @job_content = @client.job_contents.find(params[:id])
    set_job_content_skill_list_to_gon
  end

  def create
    @job_content = @client.job_contents.build(job_content_params)
    if @job_content.save
      redirect_to client_path(clientname: @client.clientname), flash: { success: I18n.t('views.job_content.success.create_job_content') }
    else
      set_job_content_skill_list_to_gon
      render :new
    end
  end

  def update
    @job_content = @client.job_contents.find(params[:id])
    if @job_content.update_attributes(job_content_params)
      redirect_to client_path(clientname: @client.clientname), flash: { success: I18n.t('views.job_content.success.update_job_content') }
    else
      set_job_content_skill_list_to_gon
      render :edit
    end
  end

  def destroy
    @job_content = @client.job_contents.find(params[:id])
    @job_content_title = @job_content.title
    @job_content.destroy!
    redirect_to client_path(clientname: @client.clientname), flash: { success: I18n.t('views.job_content.success.delete_job_content', title: @job_content_title) }
  end

  private

  def job_content_params
    params.require(:job_content).permit(:title, :content, :skill_list, :note, :start_date, :finish_date)
  end

  def signed_in_client
    unless signed_in?
      store_location
      redirect_to sign_in_url, flash: { danger: I18n.t('views.common.info.danger.not_signed_in') }
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
