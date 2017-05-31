def clean_data
  Worker.delete_all
  WorkerProfile.delete_all
  ActsAsTaggableOn::Tagging.delete_all
  Client.delete_all
  ClientUser.delete_all
  JobContent.delete_all
  Agreement.delete_all
  Chat.delete_all
  JobRequest.delete_all
end

def workers
  100.times do |index|
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
      location: '02',
      employment_history1: 'Lobo 株式会社',
      skill_list: 'Ruby, PHP, C, HTML, css, JavaScript, jQuery'
    )
    worker_profile.save
  end
end

def client
  50.times do |index|
    com_name = Faker::Company.name
    logo = Rails.root.join('spec/fixtures/images/lobo.png').open
    user_name = Faker::Name
    last_name = user_name.last_name
    first_name = user_name.first_name
    Timecop.travel(Time.zone.local(2017, 1, 1))
    title = 'Test title'
    content = Faker::Lorem.sentence(300)
    note = Faker::Lorem.sentence(100)
    start_date = Time.zone.local(2017, 5, 16)
    finish_date = Time.zone.local(2017, 9, 19)

    client = Client.create(
      name: com_name,
      corporate_site: "http://client_example#{index + 1}.com",
      clientname: "example_client#{index + 1}",
      location: '01',
      logo: logo
    )

    client.client_users.create(
      last_name: last_name,
      first_name: first_name,
      username: "example_client_user#{index + 1}",
      email: "client_user#{index + 1}@example.com",
      password: 'foobar123',
      password_confirmation: 'foobar123',
      activated: true
    )

    client.job_contents.create(
      title: title,
      content: content,
      skill_list: 'Ruby, PHP, C, HTML, css, JavaScript, jQuery',
      note: note,
      start_date: start_date,
      finish_date: finish_date
    )
  end
end

def agreement
  job_contents = JobContent.all
  workers = Worker.all

  job_contents.each do |i|
    i.agreements.create(
      worker_id: workers.sample.id,
      active: true,
      activated_at: Time.zone.local(2017, 5, 10)
    )
  end
end/application_cable/connection.rb

clean_data
workers
client
agreement
