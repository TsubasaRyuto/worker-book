module Chats
  class File < ApplicationRecord
    belongs_to :chat
  end
end
