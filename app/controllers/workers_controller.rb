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
  def new
    @worker = Worker.new
  end

  def create
    @worker = Worker.new(worker_params)
    if @worker.save
      @worker.send_activation_email
      redirect_to root_url, flash: { success: t('info.messages.flash_check_email') }
    else
      render :new
    end
  end

  def activate
    worker = Worker.find_by(email: params[:email])
    if worker && !worker.activated? && worker.authenticated?(activation, paramas[:id])
      worker.update_attribute(:activated, true)
      worker.update_attribute(:activated_at, Time.zone.now)
      login worker
      flash[:success] = 'アカウント登録完了'
      redirect_to worker_create_profile_url
    else
      flash[:danger] = '失敗'
      redirect_to roo_url
    end
  end

  private

  def worker_params
    params.require(:worker).permit(:last_name, :first_name, :username, :email, :password, :password_confirmation)
  end
end
