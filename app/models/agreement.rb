class Agreement < ApplicationRecord
  belongs_to :job_content
  belongs_to :worker
  has_many :chats
  delegate :client, to: :job_content
end

# == Schema Information
#
# Table name: agreements
#
#  id             :integer          not null, primary key
#  worker_id      :integer          not null
#  job_content_id :integer          not null
#  active         :boolean          default(TRUE), not null
#  activated_at   :datetime
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
# Indexes
#
#  index_agreements_on_job_content_id  (job_content_id)
#  index_agreements_on_worker_id       (worker_id)
#
