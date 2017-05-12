require 'rails_helper'

RSpec.describe JobContent, type: :model do
  let(:client) { create :client }
  let(:title) { '女性向けiphoneアプリ' }
  let(:content) { 'test' * 50 }
  let(:skills) { %w(Ruby PHP Python HTML jQuery) }
  let(:note) { 'example ' * 10 }
  let(:start_date) { Time.zone.local(2017, 5, 16) }
  let(:finish_date) { Time.zone.local(2017, 9, 19) }
  let(:job_content) { client.job_contents.build(
    title: title, content: content, skill_list: skills,
    note: note, start_date: start_date, finish_date: finish_date
    ) }

  context 'validates' do
    context 'successful' do
      it { expect(job_content).to be_valid }
    end

    context 'failed' do
      context 'title' do
        context 'present' do
          let(:title) { '' }
          it { expect(job_content).to be_invalid }
        end
        context 'too long' do
          let(:title) { 'a' * 71 }
          it { expect(job_content).to be_invalid }
        end
      end

      context 'content' do
        context 'present' do
          let(:content) { '' }
          it { expect(job_content).to be_invalid }
        end
        context 'too long' do
          let(:content) { 'a' * 3001 }
          it { expect(job_content).to be_invalid }
        end
      end

      context 'skill_list' do
        context 'maximum' do
          let(:skills) { %w(Ruby C css HTML jQuery PHP C++ AWS CoffeeScript JavaScript CakePHP) }
          it { expect(job_content).to be_invalid }
        end
      end

      context 'note' do
        context 'present' do
          let(:note) { '' }
          it { expect(job_content).to be_invalid }
        end

        context 'too long' do
          let(:title) { 'a' * 1001 }
          it { expect(job_content).to be_invalid }
        end
      end

      context 'start_date' do
        context 'present' do
          let(:start_date) { '' }
          it { expect(job_content).to be_invalid }
        end

        context ' start_date_should_be_before_finish_date' do
          let(:start_date) { Time.zone.local(2017, 5, 16) }
          let(:finish_date) { Time.zone.local(2017, 5, 15) }
          it { expect(job_content).to be_invalid }
        end
      end
      context 'finish_date' do
        context 'present' do
          let(:finish_date) { '' }
          it { expect(job_content).to be_invalid }
        end
      end
    end
  end
end
