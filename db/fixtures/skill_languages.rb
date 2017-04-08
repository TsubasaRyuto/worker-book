require 'csv'

csv = CSV.read('db/fixtures/skill.csv')
csv.each do |skill|
  name = skill[0]

  SkillLanguage.seed(:name) do |s|
    s.name = name
  end
end
