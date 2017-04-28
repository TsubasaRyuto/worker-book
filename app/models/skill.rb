class Skill < ApplicationRecord
  has_many :worker_skills
  has_many :workers, through: :worker_skills

  scope :autocomplete, ->(term) { where('name LIKE ?', "#{term}%").order(:name) }
end

# == Schema Information
#
# Table name: skills
#
#  id                  :integer          not null, primary key
#  name                :string(255)      not null
#  worker_skills_count :integer          default(0), not null
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#
