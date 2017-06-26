class Chat < ApplicationRecord
  after_create_commit { MessageBroadcastJob.perform_later self }

  belongs_to :agreement
  has_many :chat_images, dependent: :destroy, class_name: 'ChatImage'
  has_many :chat_file, dependent: :destroy, class_name: 'Chatfile'
  delegate :worker, to: :agreement
  delegate :client, to: :agreement

  validates :message, presence: true, length: { maximum: 3000 }
  validates :sender_username, presence: true
  validates :receiver_username, presence: true
end

# == Schema Information
#
# Table name: chats
#
#  id                :integer          not null, primary key
#  agreement_id      :integer          not null
#  sender_username   :string(255)      not null
#  receiver_username :string(255)      not null
#  message           :text(65535)      not null
#  read_flg          :boolean          default(FALSE), not null
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#
# Indexes
#
#  index_chats_on_agreement_id  (agreement_id)
#
