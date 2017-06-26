if Rails.env == 'production' || Rails.env == 'staging'
  ActionMailer::Base.add_delivery_method :aws_ses,
                                         AWS::SES::Base,
                                         region: 'us-east-1',
                                         access_key_id: ENV['AWS_ACCESS_KEY_ID'],
                                         secret_access_key: ENV['AWS_SECRET_ACCESS_KEY'],
                                         server: 'email.us-east-1.amazonaws.com'
end
