FactoryGirl.define do
  factory :client_user do
    name = Faker::Name
    last_name { name.last_name }
    first_name { name.first_name }
    username 'example_client_user'
    email 'client_user@example.com'
    password 'foobar123'
    password_confirmation 'foobar123'
    activated true
    activated_at Time.zone.now
  end

  factory :other_client_user, class: ClientUser do
    name = Faker::Name
    last_name { name.last_name }
    first_name { name.first_name }
    username 'example_client_user2'
    email 'client_user2@example.com'
    password 'foobar123'
    password_confirmation 'foobar123'
    activated true
    activated_at Time.zone.now
  end
end
