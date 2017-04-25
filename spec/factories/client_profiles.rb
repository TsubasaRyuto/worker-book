FactoryGirl.define do
  factory :client_profile, class: ClientProfile do
    corporate_site 'http://example.com'
    logo { Rack::Test::UploadedFile.new(File.join(Rails.root, '/spec/fixtures/images/lobo.png'), 'image/png') }
  end
end
