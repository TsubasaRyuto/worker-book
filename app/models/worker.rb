class Worker < ApplicationRecord
  include UserSignUp

  before_save :downcase_email, :downcase_username
  before_create :create_activation_digest

  has_many :agreements
  has_many :job_requests
  has_many :chats, through: :agreements
  has_one :account, dependent: :destroy, foreign_key: 'id', class_name: 'WorkerAccount'
  has_one :address, dependent: :destroy, foreign_key: 'id', class_name: 'WorkerAddress'
  has_one :profile, dependent: :destroy, foreign_key: 'id', class_name: 'WorkerProfile'

  MIN_LENGTH_PASSWORD = 8

  validates :last_name, presence: true, name_max_length: true
  validates :first_name, presence: true, name_max_length: true
  validates :username, presence: true, username: true, username_unique: true
  validates :email, presence: true, email: true, email_unique: true
  has_secure_password
  validates :password, presence: true, length: { minimum: MIN_LENGTH_PASSWORD }, allow_nil: true  

  def send_request_email(client, job_content, job_request)
    WorkerMailer.request_job(self, client, job_content, job_request).deliver_now
  end
end

# == Schema Information
#
# Table name: workers
#
#  id                :integer          not null, primary key
#  last_name         :string(255)      not null
#  first_name        :string(255)      not null
#  username          :string(255)      not null
#  email             :string(255)      not null
#  password_digest   :string(255)      not null
#  remember_digest   :string(255)
#  activation_digest :string(255)
#  activated         :boolean          default(FALSE), not null
#  activated_at      :datetime
#  reset_digest      :string(255)
#  reset_sent_at     :datetime
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#
