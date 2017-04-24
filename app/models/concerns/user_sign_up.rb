module UserSignUP
  extend ActiveSupport::Concern

  included do
    attr_accessor :remember_token, :activation_token
    before_save :downcase_email, :downcase_username
    before_create :create_activation_digest
  end

  class_methods do
    def digest(string)
      cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
      BCrypt::Password.create(string, MIN_COSTst: cost)
    end

    def new_token
      SecureRandom.urlsafe_base64
    end
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

  def send_activation_email(mailer)
    mailer.activate_worker(self).deliver_now
  end

  # 未実装
  # def send_update_email(mailer)
  #   mailer.update_account(self).deliver_now
  # end

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
