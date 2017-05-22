class MessageBroadcastJob < ApplicationJob
  queue_as :default

  def perform(chat)
    receiver = Worker.find_by(username: chat.receiver_username) || ClientUser.find_by(username:  chat.receiver_username)
    ChatChannel.broadcast_to(receiver, message: render_message(chat))
    ChatChannel.broadcast_to(current_user, message: render_message(chat))
  end

  private

  def render_message(message)
    ApplicationController.renderer.render(partial: 'chats/chat', locals: { chat: message })
  end
end
