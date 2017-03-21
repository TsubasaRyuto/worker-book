module Chats
  class Image < ApplicationRecord
    belongs_to :chat
  end
end
