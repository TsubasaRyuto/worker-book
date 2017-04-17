class WorkerProfile < ApplicationRecord
  mount_uploader :picture, ProfilePictureUploader

  attr_accessor :type

  self.table_name = 'worker_profiles'
  self.primary_key = :id
  belongs_to :worker, foreign_key: 'id'
  before_create { self.id = self.worker.id }

  enum availability: { limited: 0, full: 1, hard: 2 }

  MAX_LENGTH = 3000
  MIN_LENGTH = 400
  UNIT_PRICE_REGEX = /\A[0-9]+$\Z/
  URL_REGEX = /\A#{URI.regexp(%w(http https))}\z/

  validates :id, uniqueness: true
  validates :type, presence_developer_type: true, max_count_developer_type: true
  validates :past_performance1, presence: true, format: { with: URL_REGEX }, past_performance_duplicate: true
  validates :past_performance2, presence: true, format: { with: URL_REGEX }, past_performance_duplicate: true
  with_options unless: 'past_performance3.blank?' do |n|
    n.validates :past_performance3, format: { with: URL_REGEX }, past_performance_duplicate: true
  end
  with_options unless: 'past_performance4.blank?' do |n|
    n.validates :past_performance4, format: { with: URL_REGEX }, past_performance_duplicate: true
  end
  validates :unit_price, presence: true, inclusion: { in: 30_000..200_000 }, format: { with: UNIT_PRICE_REGEX }
  validates :appeal_note, presence: true, length: { maximum: MAX_LENGTH, minimum: MIN_LENGTH }
  validates :location, presence: true
  validates :picture, presence: true
  validates :employment_history1, presence: true, length: { minimum: 2 }
  with_options unless: 'employment_history2.blank?' do |n|
    n.validates :employment_history2, length: { minimum: 2 }
  end
  with_options unless: 'employment_history3.blank?' do |n|
    n.validates :employment_history3, length: { minimum: 2 }
  end
  with_options unless: 'employment_history4.blank?' do |n|
    n.validates :employment_history4, length: { minimum: 2 }
  end
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
#  location                :string(255)      not null
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
