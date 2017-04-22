class Worker < ApplicationRecord
  attr_accessor :remember_token, :activation_token

  before_save :downcase_email, :downcase_username
  before_create :create_activation_digest

  has_many :worker_skills, dependent: :destroy
  has_many :skill_languages, through: :worker_skills
  has_many :agreements
  has_one :account, dependent: :destroy, foreign_key: 'id', class_name: 'WorkerAccount'
  has_one :address, dependent: :destroy, foreign_key: 'id', class_name: 'WorkerAddress'
  has_one :profile, dependent: :destroy, foreign_key: 'id', class_name: 'WorkerProfile'

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  MAX_LENGTH_EMAIL = 100
  MAX_LENGTH_NAME = 30
  MIN_LENGTH_NAME = 5
  MIN_LENGTH_PASSWORD = 8
  VALID_USERNAME_REGEX = /\A[a-z\d_]{5,30}\Z/

  validates :last_name, presence: true, length: { maximum: MAX_LENGTH_NAME }
  validates :first_name, presence: true, length: { maximum: MAX_LENGTH_NAME }
  validates :username, presence: true
  validates :username, length: { maximum: MAX_LENGTH_NAME, minimum: MIN_LENGTH_NAME }, uniqueness: { case_sensitive: false }, format: { with: VALID_USERNAME_REGEX }, allow_blank: true
  validates :email, presence: true
  validates :email, length: { maximum: MAX_LENGTH_EMAIL }, format: { with: VALID_EMAIL_REGEX }, uniqueness: { case_sensitive: false }, allow_blank: true
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
    self.remember_token = Worker.new_token
    update_attribute(:remember_digest, Worker.digest(remember_token))
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
    WorkerMailer.activate_worker(self).deliver_now
  end

  def send_update_email
    WorkerMailer.update_account(self).deliver_now
  end

  def forget
    update_attribute(:remember_digest, nil)
  end

  private

  def downcase_email
    self.email = email.downcase
  end

  def downcase_username
    self.username = username.downcase
  end

  def create_activation_digest
    self.activation_token = Worker.new_token
    self.activation_digest = Worker.digest(activation_token)
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
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#
