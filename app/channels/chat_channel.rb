class ChatChannel < ApplicationCable::Channel
  def subscribed
    @receiver = Worker.find_by(username: params[:partner_username]) || ClientUser.find_by(username: params[:partner_username])
    stream_for @receiver
    stream_for current_user
  end

  def unsubscribed; end

  def speak(data)
    @agreement = (@receiver.client.agreements & current_user.agreements).first if current_user.class == Worker
    @agreement = (@receiver.agreements & current_user.client.agreements).first if current_user.class == ClientUser
    @agreement.chats.create!(message: data['message'], sender_username: current_user.username, receiver_username: @receiver.username)
  end
end
