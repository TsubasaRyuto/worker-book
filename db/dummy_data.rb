def clean_data
  Worker.delete_all
  WorkerProfile.delete_all
  ActsAsTaggableOn::Tagging.delete_all
  Client.delete_all
end

def workers
  2.times do |index|
    name = Faker::Name
    last_name = name.last_name
    first_name = name.first_name
    availability = WorkerProfile.availabilities.keys.sample
    note = Faker::Lorem.sentence(400)
    picture = Rails.root.join('spec/fixtures/images/lobo.png').open

    worker = Worker.create(
      last_name: last_name,
      first_name: first_name,
      username: "example_worker#{index + 1}",
      email: "worker#{index + 1}@example.com",
      password: 'foobar123',
      password_confirmation: 'foobar123',
      activated: true
    )

    worker_profile = worker.build_profile(
      type_web_developer: true,
      type_mobile_developer: true,
      availability: availability,
      past_performance1: 'http://example1.com',
      past_performance2: 'http://example2.com',
      unit_price: 40_000,
      appeal_note: note,
      picture: picture,
      location: 02,
      employment_history1: 'Lobo 株式会社',
      skill_list: 'Ruby, PHP, C, HTML, css, JavaScript, jQuery'
    )
    worker_profile.save
  end
end

def client
  2.times do |index|
    name = Faker::Name
    last_name = name.last_name
    first_name = name.first_name
    com_name = Faker::Company.name
    logo = Rails.root.join('spec/fixtures/images/lobo.png').open

    client = Client.create(
      last_name: last_name,
      first_name: first_name,
      username: "example_client#{index + 1}",
      company_name: com_name,
      email: "client#{index + 1}@example.com",
      password: 'foobar123',
      password_confirmation: 'foobar123',
      activated: true
    )

    client_profile = client.build_profile(
      corporate_site: "http://client_example#{index + 1}.com",
      logo: logo
    )
    client_profile.save
  end
end

clean_data
workers
client
