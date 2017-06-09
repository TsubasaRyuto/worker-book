require 'csv'

csv = CSV.read('db/fixtures/skill.csv')
csv.each do |skill|
  name = skill[0]

  ActsAsTaggableOn::Tag.seed(:name) do |s|
    s.name = name
  end
end
