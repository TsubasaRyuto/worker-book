FactoryGirl.define do
  factory :worker_profile, class: WorkerProfile do
    type_web_developer true
    type_mobile_developer true
    type_game_developer true
    type_desktop_developer false
    type_ai_developer false
    type_qa_testing false
    type_web_mobile_desiner false
    type_project_maneger false
    type_other false
    availability 'limited'
    past_performance1 'http://example.com'
    past_performance2 'http://example2.com'
    unit_price 40_000
    appeal_note 'test hoge foo bar' * 80
    picture { Rack::Test::UploadedFile.new(File.join(Rails.root, '/spec/fixtures/images/lobo.png'), 'image/png') }
    location 02
    employment_history1 'example company'
    currently_freelancer true
    active true
    skill_list 'Ruby, PHP, Python, HTML, jQuery'
  end
end
