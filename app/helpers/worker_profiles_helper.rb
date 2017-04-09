module WorkerProfilesHelper
  def developer_type_list(worker_profile)
    type_name = [
      'web_developer', 'mobile_developer', 'game_developer', 'desktop_developer',
      'ai_developer', 'qa_testing', 'web_mobile_desiner', 'project_maneger', 'other'
    ]
    type_values = type_name.map.select { |name| worker_profile.__send__("type_#{name}") }
  end
end
