class WorkerSkill < ApplicationRecord
  belongs_to :worker
  belongs_to :skill

  counter_culture :skill, column_name: 'worker_skills_count'

  validates :worker_id, presence: true
  validates :skill_id, presence: true

  validate :max_count_worker_skill, :min_count_worker_skill, :duplicate_worker_skill

  private

  def max_count_worker_skill
    if worker && worker.worker_skills.size + worker.worker_skills.count >= 10
      errors.add(:worker_skill, I18n.t('activerecord.errors.worker_skills.too_many'))
    end
  end

  def min_count_worker_skill
    if worker && worker.worker_skills.size + worker.worker_skills.count < 5
      errors.add(:worker_skill, I18n.t('activerecord.errors.worker_skills.too_little'))
    end
  end

  def duplicate_worker_skill
    worker_skills = worker.worker_skills
    skill_ids = []
    worker_skills.each do |s|
      skill_id = s.skill_id
      skill_ids.push(skill_id)
    end
    unless worker && skill_ids.size == skill_ids.uniq.size
      errors.add(:worker_skill, I18n.t('activerecord.errors.worker_skills.duplicate'))
    end
  end
end

# == Schema Information
#
# Table name: worker_skills
#
#  id         :integer          not null, primary key
#  worker_id  :integer          not null
#  skill_id   :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_worker_skills_on_skill_id   (skill_id)
#  index_worker_skills_on_worker_id  (worker_id)
#
