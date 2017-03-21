module Workers
  class Skill < ApplicationRecord
    self.table_name = 'worker_skills'
    belongs_to :worker
    belongs_to :skill_language
  end
end

# == Schema Information
#
# Table name: worker_skills
#
#  id                :integer          not null, primary key
#  worker_id         :integer          not null
#  skill_language_id :integer          not null
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#
# Indexes
#
#  index_worker_skills_on_skill_language_id  (skill_language_id)
#  index_worker_skills_on_worker_id          (worker_id)
#
