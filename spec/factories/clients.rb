FactoryGirl.define do
  factory :client do
    name 'Example株式会社'
    clientname 'exampleclient'
    location 02
    corporate_site 'http://example.com'
    logo { Rack::Test::UploadedFile.new(File.join(Rails.root, '/spec/fixtures/images/lobo.png'), 'image/png') }
  end
end
