class Inquiry
  include ActiveModel::Model

  attr_accessor :name, :email, :inquiry_title, :message

  MAXLENGTH = 30
  MAX_MESSAGE = 3000

  validates :name, presence: true, length: { maximum: MAXLENGTH }
  validates :email, presence: true, email: true
  validates :inquiry_title, presence: true, length: { maximum: MAXLENGTH }
  validates :message, presence: true, length: { maximum: MAX_MESSAGE }

  def send_inquiry_recieved_email()
    InquiryMailer.recieved_email(self).deliver_now
  end

  def send_inquiry_sended_email
    InquiryMailer.sended_email(self).deliver_now
  end
end
