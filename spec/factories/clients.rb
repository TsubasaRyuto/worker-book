FactoryGirl.define do
  factory :client do
    name 'Example株式会社'
    clientname 'exampleclient'
    location 02
    corporate_site 'http://example.com'
    logo { Rack::Test::UploadedFile.new(File.join(Rails.root, '/spec/fixtures/images/lobo.png'), 'image/png') }
  end

  factory :other_client, class: Client do
    name 'Example2株式会社'
    clientname 'exampleclient2'
    location 02
    corporate_site 'http://example2.com'
    logo { Rack::Test::UploadedFile.new(File.join(Rails.root, '/spec/fixtures/images/lobo.png'), 'image/png') }
  end
end
