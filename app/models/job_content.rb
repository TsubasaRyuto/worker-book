class JobContent < ApplicationRecord
  belongs_to :client
  has_many :agreements
end

# == Schema Information
#
# Table name: job_contents
#
#  id              :integer          not null, primary key
#  client_id       :integer          not null
#  title           :string(255)      not null
#  content         :text(65535)      not null
#  skill_language  :text(65535)
#  past_experience :text(65535)      not null
#  start_date      :datetime         not null
#  finish_date     :datetime         not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
# Indexes
#
#  index_job_contents_on_client_id  (client_id)
#
