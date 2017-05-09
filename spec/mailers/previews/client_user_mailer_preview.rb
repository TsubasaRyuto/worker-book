# Preview all emails at http://localhost:3000/rails/mailers/client_mailer
class ClientUserMailerPreview < ActionMailer::Preview
  def activate_client
    client = ClientUser.first
    client.activation_token = Client.new_token
    ClientUserMailer.activate_client(client)
  end

  def password_reset
    ClientUserMailer.password_reset
  end
end
