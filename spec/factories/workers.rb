FactoryGirl.define do
  factory :worker do
    name = Faker::Name
    last_name { name.last_name }
    first_name { name.first_name }
    username 'example_worker'
    email 'worker@example.com'
    password 'foobar123'
    password_confirmation 'foobar123'
    activated true
    activated_at Time.zone.now
  end

  factory :other_worker, class: Worker do
    name = Faker::Name
    last_name { name.last_name }
    first_name { name.first_name }
    username 'example_worker2'
    email 'worker2@example.com'
    password 'foobar123'
    password_confirmation 'foobar123'
    activated true
    activated_at Time.zone.now
  end
end
