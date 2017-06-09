class DeveloperType
  ROWS = {
    '1'.freeze => 'Web Developer'.freeze,
    '2'.freeze => 'Mobile Developer'.freeze,
    '3'.freeze => 'Game Developer'.freeze,
    '4'.freeze => 'Desktop Developer'.freeze,
    '5'.freeze => 'AI Developer'.freeze,
    '6'.freeze => 'QA&Testing'.freeze,
    '7'.freeze => 'Web&Mobile Desiner'.freeze,
    '8'.freeze => 'Project Maneger'.freeze,
    '9'.freeze => 'Other.freeze'
  }.freeze

  ROWS2 = {
    '1'.freeze => 'type_web_developer'.freeze,
    '2'.freeze => 'type_mobile_developer'.freeze,
    '3'.freeze => 'type_game_developer'.freeze,
    '4'.freeze => 'type_desktop_developer'.freeze,
    '5'.freeze => 'type_ai_developer'.freeze,
    '6'.freeze => 'type_qa_testing'.freeze,
    '7'.freeze => 'type_web_mobile_desiner'.freeze,
    '8'.freeze => 'type_project_maneger'.freeze,
    '9'.freeze => 'type_other'.freeze
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
