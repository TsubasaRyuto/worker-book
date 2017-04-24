class Client < ApplicationRecord
  attr_accessor :remember_token, :activation_token
  before_save :downcase_email, :downcase_username
  before_create :create_activation_digest

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

  def self.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
    BCrypt::Password.create(string, MIN_COSTst: cost)
  end

  def self.new_token
    SecureRandom.urlsafe_base64
  end

  def remember
    self.remember_token = Client.new_token
    update_attribute(:remember_digest, Client.digest(remember_token))
  end

  def authenticated?(attribute, token)
    digest = send("#{attribute}_digest")
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password?(token)
  end

  def activate
    update_attribute(:activated, true)
    update_attribute(:activated_at, Time.zone.now)
  end

  def send_activation_email
    ClientMailer.activate_client(self).deliver_now
  end

  def send_update_email
    ClientMailer.update_account(self).deliver_now
  end

  def forget
    update_attribute(:remember_digest, nil)
  end

  def create_reset_digest
    self.reset_token = Client.new_token
    update_attribute(:reset_digest,  Client.digest(reset_token))
    update_attribute(:reset_sent_at, Time.zone.now)
  end

  def send_password_reset_email
    ClientMailer.password_reset(self).deliver_now
  end

  def password_reset_expired?
    reset_sent_at < 2.hours.ago
  end

  private

  def downcase_email
    self.email = email.downcase
  end

  def downcase_username
    self.username = username.downcase
  end

  def create_activation_digest
    self.activation_token = Client.new_token
    self.activation_digest = Client.digest(activation_token)
  end
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
