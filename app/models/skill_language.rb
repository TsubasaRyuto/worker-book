class SkillLanguage < ApplicationRecord
  has_many :skills, class_name: 'Workers::Skill'
end

# == Schema Information
#
# Table name: skill_languages
#
#  id         :integer          not null, primary key
#  name       :string(255)      not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
