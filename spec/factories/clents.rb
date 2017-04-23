FactoryGirl.define do
  factory :client do
    name = Faker::Name
    last_name { name.last_name }
    first_name { name.first_name }
    username 'example_client'
    email 'client@example.com'
    company_name 'Example株式会社'
    password 'foobar123'
    password_confirmation 'foobar123'
    activated true
    activated_at Time.zone.now
  end

  factory :other_client, class: Client do
    name = Faker::Name
    last_name { name.last_name }
    first_name { name.first_name }
    username 'example_client2'
    company_name 'Example２株式会社'
    email 'client2@example.com'
    password 'foobar123'
    password_confirmation 'foobar123'
    activated true
    activated_at Time.zone.now
  end
end
