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
    model_name = sort_out_model
    self.remember_token = model_name.new_token
    update_attribute(:remember_digest, model_name.digest(remember_token))
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
    if self.class == Worker
      WorkerMailer.activate_worker(self).deliver_now
    elsif self.class == Client
      ClientMailer.activate_client(self).deliver_now
    end
  end

  # 未実装
  # def send_update_email(mailer)
  #   mailer.update_account(self).deliver_now
  # end

  def forget
    update_attribute(:remember_digest, nil)
  end

  def create_reset_digest
    model_name = sort_out_model
    self.reset_token = model_name.new_token
    update_attribute(:reset_digest,  model_name.digest(reset_token))
    update_attribute(:reset_sent_at, Time.zone.now)
  end

  def send_password_reset_email
    if self.class == Worker
      mailer = WorkerMailer
    elsif self.class == Client
      mailer = ClientMailer
    end
    mailer.password_reset(self).deliver_now
  end

  def password_reset_expired?
    reset_sent_at < 2.hours.ago
  end

  private

  def sort_out_model
    if self.class == Worker
      Worker
    elsif self.class == Client
      Client
    end
  end

  def downcase_email
    self.email = email.downcase
  end

  def downcase_username
    self.username = username.downcase
  end

  def create_activation_digest
    model_name = sort_out_model
    self.activation_token = model_name.new_token
    self.activation_digest = model_name.digest(activation_token)
  end
end
