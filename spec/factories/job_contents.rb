FactoryGirl.define do
  factory :job_content do
    title 'test title'
    content 'test content' * 100
    skill_list 'Ruby, PHP, Python, HTML, jQuery'
    start_date Date.new(2017, 5, 16)
    finish_date Date.new(2017, 9, 19)
    note 'test hoge foo bar' * 10
  end
end
