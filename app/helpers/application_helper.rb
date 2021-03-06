module ApplicationHelper

  def full_title(page_title = '')
    base_title = 'WorkerBook(α) - ITフリーランスのためのクラウドソーシングサービス'
    if page_title.empty?
      base_title
    else
      page_title + ' | ' + base_title
    end
  end

  def worker_profile_present?
    @user_profile = WorkerProfile.find_by(id: current_user.id)
    !@user_profile.nil?
  end
end
