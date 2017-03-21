module Chats
  class File < ApplicationRecord
    self.table_name = 'chat_files'
    belongs_to :chat
  end
end

# == Schema Information
#
# Table name: chat_files
#
#  id         :integer          not null, primary key
#  chat_id    :integer          not null
#  filename   :string(255)      not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_chat_files_on_chat_id  (chat_id)
#
