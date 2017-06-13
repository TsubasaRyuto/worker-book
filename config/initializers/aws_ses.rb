if Rails.env == 'production' || Rails.env == 'staging'
  ActionMailer::Base.add_delivery_method :aws_sdk,
                                         AWS::SES::Base,
                                         access_key_id: ENV['AWS_SES_ACCESS_KEY_ID'],
                                         secret_access_key: ENV['AWS_SES_SECRET_ACCESS_KEY'],
                                         server: 'inbound-smtp.us-east-1.amazonaws.com'
end
