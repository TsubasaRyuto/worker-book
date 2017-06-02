class DeveloperType
  ROWS = {
    '1': 'Web Developer',
    '2': 'Mobile Developer',
    '3': 'Game Developer',
    '4': 'Desktop Developer',
    '5': 'AI Developer',
    '6': 'QA&Testing',
    '7': 'Web&Mobile Desiner',
    '8': 'Project Maneger',
    '9': 'Other'
  }.freeze

  ROWS2 = {
    '1': 'type_web_developer',
    '2': 'type_mobile_developer',
    '3': 'type_game_developer',
    '4': 'type_desktop_developer',
    '5': 'type_ai_developer',
    '6': 'type_qa_testing',
    '7': 'type_web_mobile_desiner',
    '8': 'type_project_maneger',
    '9': 'type_other'
  }.freeze

  def self.name
    options = []
    ROWS.each do |k, v|
      options << [v, k]
    end
    options
  end

  def self.col_name(key)
    ROWS2[:"#{key}"]
  end
end
