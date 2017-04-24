module ApplicationHelper

  def full_title(page_title = '')
    base_title = 'WorkerBook'
    if page_title.empty?
      base_title
    else
      page_title + ' | ' + base_title
    end
  end

  def worker_profile_present?
    @worker_profile = WorkerProfile.find_by(id: current_user.id)
    !@worker_profile.nil?
  end
end
