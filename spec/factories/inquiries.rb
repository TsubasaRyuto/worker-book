FactoryGirl.define do
  factory :inquiry do
    name Faker::Name.name
    email 'test_user@example.com'
    inquiry_title 'Test title'
    message Faker::Lorem.sentence
  end
end
