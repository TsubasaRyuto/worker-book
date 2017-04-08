class Chat < ApplicationRecord
  belongs_to :agreement
  has_many :chat_images, dependent: :destroy, class_name: 'ChatImage'
  has_many :chat_file, dependent: :destroy, class_name: 'Chatfile'
end

# == Schema Information
#
# Table name: chats
#
#  id           :integer          not null, primary key
#  agreement_id :integer          not null
#  message      :text(65535)      not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
# Indexes
#
#  index_chats_on_agreement_id  (agreement_id)
#
