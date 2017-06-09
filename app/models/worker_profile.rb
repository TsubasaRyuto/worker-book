class WorkerProfile < ApplicationRecord
  mount_uploader :picture, PictureUploader

  attr_accessor :type, :past_performance, :employment_history

  acts_as_taggable
  acts_as_taggable_on :skill

  self.table_name = 'worker_profiles'
  self.primary_key = :id
  belongs_to :worker, foreign_key: 'id'
  before_create { self.id = self.worker.id }

  enum availability: { limited: 0, full: 1, hard: 2 }
  enum unit_price_class: { medium: '¥30,000 - ¥50,000', large: '¥50,000 - ¥70,000', extra_large: '¥70,000 - ¥100,000', over: '¥100,000 -' }

  MAX_LENGTH = 3000
  MIN_LENGTH = 400
  UNIT_PRICE_REGEX = /\A[0-9]+$\Z/

  validates :id, uniqueness: true
  validates :type, presence_developer_type: true, max_count_developer_type: true
  validates :past_performance, past_performance_min: true, past_performance_dup: true, past_performance_format: true
  validates :unit_price, presence: true
  validates :unit_price, inclusion: { in: 30_000..200_000 }, format: { with: UNIT_PRICE_REGEX }, allow_blank: true
  validates :appeal_note, presence: true
  validates :appeal_note, length: { maximum: MAX_LENGTH, minimum: MIN_LENGTH }, allow_blank: true
  validates :location, presence: true
  validates :picture, presence: true
  validates :employment_history, emp_hist_presence: true, emp_hist_length: true
  validates :skill_list, max_count_skills: true, min_count_skills: true, duplicate_skills: true

  scope :search_worker, ->(skill, unit_price_class, developer_type) {
    if skill && unit_price_class && developer_type
      where(unit_price: unit_price_class[:low]..unit_price_class[:high]).where(developer_type).tagged_with(skill)
    elsif skill && unit_price_class
      where(unit_price: unit_price_class[:low]..unit_price_class[:high]).tagged_with(skill)
    elsif skill && developer_type
      where(developer_type).tagged_with(skill)
    elsif unit_price_class && developer_type
      where(unit_price: unit_price_class[:low]..unit_price_class[:high]).where(developer_type)
    elsif skill
      tagged_with(skill)
    elsif unit_price_class
      where(unit_price: unit_price_class[:low]..unit_price_class[:high])
    elsif developer_type
      where(developer_type)
    else
      all
    end
  }
end


# == Schema Information
#
# Table name: worker_profiles
#
#  id                      :integer          not null, primary key
#  type_web_developer      :boolean          default(FALSE), not null
#  type_mobile_developer   :boolean          default(FALSE), not null
#  type_game_developer     :boolean          default(FALSE), not null
#  type_desktop_developer  :boolean          default(FALSE), not null
#  type_ai_developer       :boolean          default(FALSE), not null
#  type_qa_testing         :boolean          default(FALSE), not null
#  type_web_mobile_desiner :boolean          default(FALSE), not null
#  type_project_maneger    :boolean          default(FALSE), not null
#  type_other              :boolean          default(FALSE), not null
#  availability            :integer          default("limited"), not null
#  past_performance1       :string(255)      not null
#  past_performance2       :string(255)
#  past_performance3       :string(255)
#  past_performance4       :string(255)
#  unit_price              :integer          default(30000), not null
#  appeal_note             :text(65535)      not null
#  picture                 :string(255)      not null
#  location                :string(255)      default("01"), not null
#  employment_history1     :string(255)      not null
#  employment_history2     :string(255)
#  employment_history3     :string(255)
#  employment_history4     :string(255)
#  currently_freelancer    :boolean          default(TRUE), not null
#  active                  :boolean          default(TRUE), not null
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#
# Indexes
#
#  index_worker_profiles_on_id  (id) UNIQUE
#
