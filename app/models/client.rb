class Client < ApplicationRecord
  has_many :job_contents, dependent: :destroy
  has_one :profile, dependent: :destroy, foreign_key: 'id', class_name: 'ClientProfile'

  MIN_LENGTH_COMPANY = 3
  MIN_LENGTH_PASSWORD = 8

  validates :last_name, presence: true, name_max_length: true
  validates :first_name, presence: true, name_max_length: true
  validates :username, presence: true, username: true, username_unique: true
  validates :email, presence: true, email: true, email_unique: true
  validates :company_name, presence: true
  validates :company_name, uniqueness: { case_sensitive: false }, length: { minimum: MIN_LENGTH_COMPANY }, allow_blank: true
  has_secure_password
  validates :password, presence: true, length: { minimum: MIN_LENGTH_PASSWORD }, allow_nil: true
end

# == Schema Information
#
# Table name: clients
#
#  id                :integer          not null, primary key
#  last_name         :string(255)      not null
#  first_name        :string(255)      not null
#  username          :string(255)      not null
#  company_name      :string(255)      not null
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
