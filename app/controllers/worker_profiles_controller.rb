# == Schema Information
#
# Table name: worker_profiles
#
#  id                      :integer          not null, primary key
#  type_web_developer      :boolean          default(FALSE), not null
#  type_mobile_developer   :boolean          default(FALSE), not null
#  type_game_developer     :boolean          default(FALSE), not null
#  type_desktop_developer  :boolean          default(FALSE), not null
#  type_ai_developer       :boolean          default(FALSE), not null
#  type_qa_testing         :boolean          default(FALSE), not null
#  type_web_mobile_desiner :boolean          default(FALSE), not null
#  type_project_maneger    :boolean          default(FALSE), not null
#  type_other              :boolean          default(FALSE), not null
#  availability            :integer          default("limited"), not null
#  past_performance1       :string(255)      not null
#  past_performance2       :string(255)
#  past_performance3       :string(255)
#  past_performance4       :string(255)
#  unit_price              :integer          default(30000), not null
#  appeal_note             :text(65535)      not null
#  picture                 :string(255)      not null
#  location                :string(255)      not null
#  employment_history1     :string(255)      not null
#  employment_history2     :string(255)
#  employment_history3     :string(255)
#  employment_history4     :string(255)
#  currently_freelancer    :boolean          default(TRUE), not null
#  active                  :boolean          default(TRUE), not null
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#
# Indexes
#
#  index_worker_profiles_on_id  (id) UNIQUE
#

class WorkerProfilesController < ApplicationController
  before_action :signed_in_worker, :correct_worker

  def new
    @worker_profile = @worker.build_profile
  end

  def edit
    @worker_profile = @worker.profile
    set_worker_skill_list_to_gon
  end

  def create
    @worker_profile = @worker.build_profile(profile_params)
    if @worker_profile.save
      flash[:success] = I18n.t('views.common.info.success.create_profile')
      redirect_to worker_url(username: @worker.username)
    else
      set_worker_skill_list_to_gon
      render :new
    end
  end

  def update
    @worker_profile = @worker.profile
    if @worker_profile.update_attributes(profile_params)
      flash[:success] = I18n.t('views.common.info.success.update_profile')
      redirect_to worker_url(username: @worker.username)
    else
      set_worker_skill_list_to_gon
      render :edit
    end
  end

  private

  def profile_params
    params.require(:worker_profile).permit(
      :skill_id, :type_web_developer, :type_mobile_developer, :type_game_developer,
      :type_desktop_developer, :type_ai_developer, :type_qa_testing, :type_web_mobile_desiner,
      :type_project_maneger, :type_other, :availability, :past_performance1, :past_performance2,
      :past_performance3, :past_performance4, :unit_price, :appeal_note, :picture, :location,
      :employment_history1, :employment_history2, :employment_history3, :employment_history4,
      :currently_freelancer, :active, :skill_list
    )
  end

  def signed_in_worker
    unless signed_in?
      store_location
      flash[:danger] = I18n.t('views.common.info.danger.not_signed_in')
      redirect_to sign_in_url
    end
  end

  def correct_worker
    @worker = Worker.find_by(username: params[:worker_username])
    redirect_to root_url unless current_user?(@worker)
  end

  def set_worker_skill_list_to_gon
    gon.worker_skills = @worker_profile.skill_list
  end
end
