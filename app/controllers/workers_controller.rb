# == Schema Information
#
# Table name: workers
#
#  id                :integer          not null, primary key
#  last_name         :string(255)      not null
#  first_name        :string(255)      not null
#  username          :string(255)      not null
#  email             :string(255)      not null
#  password_digest   :string(255)      not null
#  remember_digest   :string(255)
#  admin             :boolean          default(FALSE), not null
#  activation_digest :string(255)
#  activated         :boolean          default(FALSE), not null
#  activated_at      :datetime
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#

class WorkersController < ApplicationController
  def index; end

  def show
    @worker = Worker.find_by(username: params[:username])
    raise ActiveRecord::RecordNotFound if @worker.blank? || @worker.profile.blank?
  end


  def edit; end

  def new
    @worker = Worker.new
  end

  def create
    @worker = Worker.new(worker_params)
    if @worker.save
      @worker.send_activation_email
      session[:verify_email] = true
      redirect_to verify_email_url
    else
      render :new
    end
  end

  def activate
    worker = Worker.find_by(email: params[:email])
    raise ActiveRecord::RecordNotFound if worker.blank?
    if worker && !worker.activated? && worker.authenticated?(:activation, params[:token])
      worker.activate
      sign_in worker
      flash[:success] = I18n.t('common.info.success')
      redirect_to worker_create_profile_url(worker_username: worker.username)
    else
      flash[:danger] = I18n.t('common.info.danger')
      redirect_to root_url
    end
  end

  def autocomplete_skill
    skill_languages = SkillLanguage.autocomplete(params[:term])
    render json: skill_languages
  end

  private

  def worker_params
    params.require(:worker).permit(:last_name, :first_name, :username, :email, :password, :password_confirmation)
  end
end
