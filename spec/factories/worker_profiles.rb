FactoryGirl.define do
  factory :worker_profile, class: WorkerProfile do
    picture { Rack::Test::UploadedFile.new(File.join(Rails.root, '/spec/fixtures/images/lobo.png'), 'image/png') }
  end
end
