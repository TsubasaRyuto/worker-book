class JobRequest < ApplicationRecord
  attr_accessor :activation_token
  before_create :create_oreder_link_token

  belongs_to :job_content
  belongs_to :worker

  def digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
    BCrypt::Password.create(string, MIN_COSTst: cost)
  end

  def new_token
    SecureRandom.urlsafe_base64
  end

  private

  def create_oreder_link_token
    self.activation_token = Worker.new_token
    self.activation_digest = Worker.digest(activation_token)
  end
end

# == Schema Information
#
# Table name: job_requests
#
#  id                :integer          not null, primary key
#  worker_id         :integer          not null
#  job_content_id    :integer          not null
#  activation_digest :string(255)
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#
# Indexes
#
#  index_job_requests_on_job_content_id  (job_content_id)
#  index_job_requests_on_worker_id       (worker_id)
#
