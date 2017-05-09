class ClientUser < ApplicationRecord
  include UserSignUp

  belongs_to :client
  has_many :job_contents, dependent: :destroy

  MIN_LENGTH_PASSWORD = 8

  validates :last_name, presence: true, name_max_length: true
  validates :first_name, presence: true, name_max_length: true
  validates :username, presence: true, username: true, username_unique: true
  validates :email, presence: true, email: true, email_unique: true
  has_secure_password
  validates :password, presence: true, length: { minimum: MIN_LENGTH_PASSWORD }, allow_nil: true

  enum user_type: { admin: 0, general: 1, developer: 2 }
end

# == Schema Information
#
# Table name: client_users
#
#  id                :integer          not null, primary key
#  client_id         :integer          not null
#  last_name         :string(255)      not null
#  first_name        :string(255)      not null
#  username          :string(255)      not null
#  email             :string(255)      not null
#  user_type         :integer          default("admin")
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
# Indexes
#
#  index_client_users_on_client_id  (client_id)
#
