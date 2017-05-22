class JobContent < ApplicationRecord
  acts_as_taggable
  acts_as_taggable_on :skill

  belongs_to :client
  has_many :agreements

  MAX_LENGTH_TITLE = 70
  MAX_LENGTH_CONTENTS = 3000
  MAX_LENGTH_NOTE = 1000

  validates :title, presence: true, length: { maximum: MAX_LENGTH_TITLE }
  validates :content, presence: true, length: { maximum: MAX_LENGTH_CONTENTS }
  validates :note, presence: true, length: { maximum: MAX_LENGTH_NOTE }
  validates :skill_list, presence: true, duplicate_skills: true, max_count_skills: true
  validates :start_date, presence: true
  validates :finish_date, presence: true
  validate :start_date_should_be_before_finish_date, :start_date_should_be_after_current_date

  private

  def start_date_should_be_before_finish_date
    return unless self.start_date && self.finish_date

    if self.start_date >= self.finish_date
      errors.add(:finish_date, I18n.t('activerecord.errors.job_contents.before_finish_date'))
    end
  end

  def start_date_should_be_after_current_date
    return unless self.start_date
    if self.start_date <= Date.current
      errors.add(:start_date, I18n.t('activerecord.errors.job_contents.after_current_date'))
    end
  end
end

# == Schema Information
#
# Table name: job_contents
#
#  id          :integer          not null, primary key
#  client_id   :integer          not null
#  title       :string(255)      not null
#  content     :text(65535)      not null
#  note        :text(65535)      not null
#  start_date  :datetime         not null
#  finish_date :datetime         not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_job_contents_on_client_id  (client_id)
#
