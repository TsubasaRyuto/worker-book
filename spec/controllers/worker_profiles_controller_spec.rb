# == Schema Information
#
# Table name: worker_profiles
#
#  id                      :integer          not null, primary key
#  type_web_developer      :boolean          default(FALSE), not null
#  type_mobile_developer   :boolean          default(FALSE), not null
#  type_game_developer     :boolean          default(FALSE), not null
#  type_desktop_developer  :boolean          default(FALSE), not null
#  type_ai_developer       :boolean          default(FALSE), not null
#  type_qa_testing         :boolean          default(FALSE), not null
#  type_web_mobile_desiner :boolean          default(FALSE), not null
#  type_project_maneger    :boolean          default(FALSE), not null
#  type_other              :boolean          default(FALSE), not null
#  availability            :integer          default("limited"), not null
#  past_performance1       :string(255)      not null
#  past_performance2       :string(255)
#  past_performance3       :string(255)
#  past_performance4       :string(255)
#  unit_price              :integer          default(30000), not null
#  appeal_note             :text(65535)      not null
#  picture                 :string(255)      not null
#  location                :string(255)      not null
#  employment_history1     :string(255)      not null
#  employment_history2     :string(255)
#  employment_history3     :string(255)
#  employment_history4     :string(255)
#  currently_freelancer    :boolean          default(TRUE), not null
#  active                  :boolean          default(TRUE), not null
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#
# Indexes
#
#  index_worker_profiles_on_id  (id) UNIQUE
#

require 'rails_helper'

RSpec.describe WorkerProfilesController, truncation: true, type: :controller do
  let(:worker) { create :worker }
  context 'get new' do
    context 'success' do
      before do
        sign_in_as(worker)
        get :new, params: { worker_username: worker.username }
      end
      it 'should get new' do
        expect(response).to have_http_status :success
        expect(signed_in?).to be_truthy
        expect(worker.activated).to be_truthy
      end
    end

    context 'failed' do
      context 'with not signed in' do
        before do
          get :new, params: { worker_username: worker.username }
        end
        it 'should redirect to root' do
          expect(response).to redirect_to root_url
          expect(signed_in?).to be_falsey
        end
      end

      context 'with not activated' do
        let(:activated) { false }
        before do
          worker.activated = activated
          get :new, params: { worker_username: worker.username }
        end
        it 'should redirect to root' do
          expect(response).to redirect_to root_url
          expect(signed_in?).to be_falsey
        end
      end
    end
  end

  context 'post create' do
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
    let(:past_performance2) { 'http://example2.com' }
    let(:past_performance3) {}
    let(:past_performance4) {}
    let(:unit_price) { 40_000 }
    let(:appeal_note) { 'hoge' * 101 }
    let(:picture) { fixture_file_upload('images/lobo.png', 'image/png') }
    let(:location) { 01 }
    let(:employment_history1) { 'example company' }
    let(:employment_history2) {}
    let(:employment_history3) {}
    let(:employment_history4) {}
    let(:currently_freelancer) { true }
    let(:active) { true }
    let(:skills) { 'Ruby, HTML, css, C, PHP' }

    before do
      sign_in_as(worker)
    end

    context 'success' do
      it 'should be create worker profile' do
        expect do
          post :create, params: { worker_username: worker.username, worker_profile: {
            type_web_developer: type_web_developer, type_mobile_developer: type_mobile_developer, type_game_developer: type_game_developer,
            type_desktop_developer: type_desktop_developer, type_ai_developer: type_ai_developer, type_qa_testing: type_qa_testing, type_web_mobile_desiner: type_web_mobile_desiner,
            type_project_maneger: type_project_maneger, type_other: type_other, availability: availability, past_performance1: past_performance1, past_performance2: past_performance2,
            past_performance3: past_performance3, past_performance4: past_performance4, unit_price: unit_price, appeal_note: appeal_note, picture: picture, location: location,
            employment_history1: employment_history1, employment_history2: employment_history2, employment_history3: employment_history3, employment_history4: employment_history4,
            currently_freelancer: currently_freelancer, active: active, skill_list: skills
          } }
        end
          .to change { WorkerProfile.count }.by(1)
        expect(response).to redirect_to worker_url(username: worker.username)
        expect(flash).to be_present
      end
    end
    context 'failed with invalid information' do
      shared_examples_for 'invalid profile information' do
        before do
          post :create, params: { worker_username: worker.username, worker_profile: {
            type_web_developer: type_web_developer, type_mobile_developer: type_mobile_developer, type_game_developer: type_game_developer,
            type_desktop_developer: type_desktop_developer, type_ai_developer: type_ai_developer, type_qa_testing: type_qa_testing, type_web_mobile_desiner: type_web_mobile_desiner,
            type_project_maneger: type_project_maneger, type_other: type_other, availability: availability, past_performance1: past_performance1, past_performance2: past_performance2,
            past_performance3: past_performance3, past_performance4: past_performance4, unit_price: unit_price, appeal_note: appeal_note, picture: picture, location: location,
            employment_history1: employment_history1, employment_history2: employment_history2,
            currently_freelancer: currently_freelancer, active: active, skill_list: skills
          } }
        end
        it 'should not create worker profile' do
          expect(response).to render_template :new
        end
      end
      context 'invalid developer type' do
        context 'not present true' do
          it_behaves_like 'invalid profile information' do
            let(:type_web_developer) { false }
            let(:type_mobile_developer) { false }
            let(:type_game_developer) { false }
            let(:type_desktop_developer) { false }
            let(:type_ai_developer) { false }
            let(:type_qa_testing) { false }
            let(:type_web_mobile_desiner) { false }
            let(:type_project_maneger) { false }
            let(:type_other) { false }
          end
        end

        context 'too many select' do
          it_behaves_like 'invalid profile information' do
            let(:type_web_developer) { true }
            let(:type_mobile_developer) { true }
            let(:type_game_developer) { true }
            let(:type_desktop_developer) { true }
            let(:type_ai_developer) { true }
            let(:type_qa_testing) { true }
            let(:type_web_mobile_desiner) { true }
            let(:type_project_maneger) { true }
            let(:type_other) { true }
          end
        end
      end

      context 'invalid skill language' do
        context 'too many' do
          it_behaves_like 'invalid profile information' do
            let(:skills) { 'Ruby, HTML, css, C, PHP, AWS, jQuery, JavaScript, CoffeeScript, C++, JAVA' }
          end
        end

        context 'too little' do
          it_behaves_like 'invalid profile information' do
            let(:skills) { 'Ruby, HTML, css' }
          end
        end

        context 'duplicate' do
          it_behaves_like 'invalid profile information' do
            let(:skills) { 'Ruby, HTML, css, C, Ruby' }
          end
        end
      end

      context 'invalid past performance' do
        context 'present' do
          it_behaves_like 'invalid profile information' do
            let(:past_performance1) { '' }
            let(:past_performance2) { '' }
          end
        end
        context 'format1' do
          it_behaves_like 'invalid profile information' do
            let(:past_performance1) { '//http://exmaple.com' }
          end
        end
        context 'format2' do
          it_behaves_like 'invalid profile information' do
            let(:past_performance1) { 'httP:example.com' }
          end
        end
        context 'format3' do
          it_behaves_like 'invalid profile information' do
            let(:past_performance1) { 'httpr://example.com' }
          end
        end
        context 'formant4' do
          it_behaves_like 'invalid profile information' do
            let(:past_performance1) { 'http;//example.com' }
          end
        end
        context 'duplicate' do
          it_behaves_like 'invalid profile information' do
            let(:past_performance1) { 'http://example.com' }
            let(:past_performance2) { 'http://example.com' }
          end
        end

        context 'duplicate url3 and 4' do
          it_behaves_like 'invalid profile information' do
            let(:past_performance3) { 'http://example.com' }
            let(:past_performance4) { 'http://example.com' }
          end
        end
      end

      context 'invalid unit price' do
        context 'less than 30000' do
          it_behaves_like 'invalid profile information' do
            let(:unit_price) { 29_999 }
          end
        end

        context 'not less than 200000' do
          it_behaves_like 'invalid profile information' do
            let(:unit_price) { 200_001 }
          end
        end

        context 'format' do
          it_behaves_like 'invalid profile information' do
            let(:unit_price) { 'abc' }
          end
        end
      end

      context 'invalid appeal note' do
        context 'empty' do
          it_behaves_like 'invalid profile information' do
            let(:appeal_note) { '' }
          end
        end
        context 'too long' do
          it_behaves_like 'invalid profile information' do
            let(:appeal_note) { 'a' * 3001 }
          end
        end

        context 'too short' do
          it_behaves_like 'invalid profile information' do
            let(:appeal_note) { 'foge' * 99 }
          end
        end
      end

      context 'invalid picture' do
        context 'empty' do
          it_behaves_like 'invalid profile information' do
            let(:picture) { '' }
          end
        end
      end

      context 'invalid location' do
        it_behaves_like 'invalid profile information' do
          let(:location) { '' }
        end
      end

      context 'invalid employment_history1' do
        it_behaves_like 'invalid profile information' do
          let(:employment_history1) { '' }
        end
      end
    end
  end
end
