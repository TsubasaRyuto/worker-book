# Preview all emails at http://localhost:3000/rails/mailers/client_mailer
class ClientMailerPreview < ActionMailer::Preview
  def activate_client
    client = Client.first
    client.activation_token = Client.new_token
    ClientMailer.activate_client(client)
  end

  def password_reset
    ClientMailer.password_reset
  end
end
