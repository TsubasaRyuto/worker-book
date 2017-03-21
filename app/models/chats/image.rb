module Chats
  class Image < ApplicationRecord
    self.table_name = 'chat_images'
    belongs_to :chat
  end
end

# == Schema Information
#
# Table name: chat_images
#
#  id         :integer          not null, primary key
#  chat_id    :integer          not null
#  image      :string(255)      not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_chat_images_on_chat_id  (chat_id)
#
