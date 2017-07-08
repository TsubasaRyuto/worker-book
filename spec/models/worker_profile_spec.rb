require 'rails_helper'

RSpec.describe WorkerProfile, type: :model do
  let(:worker) { create :worker }
  let(:type_web_developer) { true }
  let(:type_mobile_developer) { true }
  let(:type_game_developer) { true }
  let(:type_desktop_developer) { true }
  let(:type_ai_developer) { false }
  let(:type_qa_testing) { false }
  let(:type_web_mobile_desiner) { false }
  let(:type_project_maneger) { false }
  let(:type_other) { false }
  let(:availability) { WorkerProfile.availabilities.invert[1] }
  let(:past_performance1) { 'http://example.com' }
  let(:past_performance2) { 'http://hogehoge.com' }
  let(:past_performance3) {}
  let(:past_performance4) {}
  let(:unit_price) { 40_000 }
  let(:appeal_note) { 'hoge' * 101 }
  let(:picture) { File.open(File.join(Rails.root, 'spec/fixtures/images/lobo.png')) }
  let(:location) { 01 }
  let(:employment_history1) { 'example company' }
  let(:employment_history2) { 'example2 comapny' }
  let(:employment_history3) {}
  let(:employment_history4) {}
  let(:currently_freelancer) { true }
  let(:active) { true }
  let(:skills) { %w(Ruby PHP Python HTML jQuery) }
  let(:worker_profile) {
    worker.build_profile(
      type_web_developer: type_web_developer, type_mobile_developer: type_mobile_developer, type_game_developer: type_game_developer,
      type_desktop_developer: type_desktop_developer, type_ai_developer: type_ai_developer, type_qa_testing: type_qa_testing, type_web_mobile_desiner: type_web_mobile_desiner,
      type_project_maneger: type_project_maneger, type_other: type_other, availability: availability, past_performance1: past_performance1, past_performance2: past_performance2,
      past_performance3: past_performance3, past_performance4: past_performance4, unit_price: unit_price, appeal_note: appeal_note, picture: picture, location: location,
      employment_history1: employment_history1, employment_history2: employment_history2, employment_history3: employment_history3, employment_history4: employment_history4,
      currently_freelancer: currently_freelancer, active: active, skill_list: skills
    )
  }

  describe 'validates' do
    context 'successfull' do
      it { expect(worker_profile).to be_valid }
    end

    context 'failed' do
      context 'developer type' do
        context 'presence' do
          let(:type_web_developer) { false }
          let(:type_mobile_developer) { false }
          let(:type_game_developer) { false }
          let(:type_desktop_developer) { false }
          let(:type_ai_developer) { false }
          let(:type_qa_testing) { false }
          let(:type_web_mobile_desiner) { false }
          let(:type_project_maneger) { false }
          let(:type_other) { false }
          it { expect(worker_profile).to be_invalid }
        end

        context 'max count' do
          let(:type_web_developer) { true }
          let(:type_mobile_developer) { true }
          let(:type_game_developer) { true }
          let(:type_desktop_developer) { true }
          let(:type_ai_developer) { true }
          let(:type_qa_testing) { false }
          let(:type_web_mobile_desiner) { false }
          let(:type_project_maneger) { false }
          let(:type_other) { false }
          it { expect(worker_profile).to be_invalid }
        end
      end

      context 'past_performance' do
        context 'presence' do
          let(:past_performance1) { '' }
          let(:past_performance2) { '' }
          it { expect(worker_profile).to be_invalid }
        end

        context 'format' do
          let(:invalid_urls) { ['//http://exmaple.com', 'httP:example.com', 'httpr://example.com', 'http;//example.com'] }
          it 'should failed validate' do
            invalid_urls.each do |url|
              worker_profile.past_performance1 = url
              expect(worker_profile).to be_invalid
            end
          end
        end

        context 'duplicate' do
          let(:past_performance1) { 'http://example.com' }
          let(:past_performance2) { 'http://example.com' }
          it { expect(worker_profile).to be_invalid }
        end
      end

      context 'unit_price' do
        context 'inclusion' do
          context 'less than 30000' do
            let(:unit_price) { 29_999 }
            it { expect(worker_profile).to be_invalid }
          end

          context 'not less than 200000' do
            let(:unit_price) { 200_001 }
            it { expect(worker_profile).to be_invalid }
          end

          context 'format' do
            let(:unit_price) { 'abcde' }
            it { expect(worker_profile).to be_invalid }
          end
        end
      end

      context 'appeal_note' do
        context 'presence' do
          let(:appeal_note) { '' }
          it { expect(worker_profile).to be_invalid }
        end

        context 'too length' do
          let(:appeal_note) { 'a' * 3001 }
          it { expect(worker_profile).to be_invalid }
        end
      end

      context 'picture' do
        context 'presence' do
          let(:picture) { '' }
          it { expect(worker_profile).to be_invalid }
        end
      end

      context 'location' do
        context 'presence' do
          let(:location) { '' }
          it { expect(worker_profile).to be_invalid }
        end
      end

      context 'employment_history' do
        context 'presence' do
          let(:employment_history1) { '' }
          let(:employment_history2) { '' }
          it { expect(worker_profile).to be_invalid }
        end
      end

      context 'skill list' do
        context 'maximum' do
          let(:skills) { %w(Ruby C css HTML jQuery PHP C++ AWS CoffeeScript JavaScript CakePHP) }
          it { expect(worker_profile).to be_invalid }
        end

        context 'minimum' do
          let(:skills) { %w(Ruby C css) }
          it { expect(worker_profile).to be_invalid }
        end
      end
    end
  end
end
