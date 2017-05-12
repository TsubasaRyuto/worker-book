# == Schema Information
#
# Table name: job_contents
#
#  id          :integer          not null, primary key
#  client_id   :integer          not null
#  title       :string(255)      not null
#  content     :text(65535)      not null
#  note        :text(65535)      not null
#  start_date  :datetime         not null
#  finish_date :datetime         not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_job_contents_on_client_id  (client_id)
#

require 'rails_helper'

RSpec.describe JobContentsController, type: :controller do
  let(:client) { create :client }
  let(:client_user) { create :client_user, client: client }

  context 'get new' do
    context 'success' do
      before do
        sign_in_as(client_user)
        get :new, params: { client_clientname: client.clientname }
      end
      it 'should get new' do
        expect(response).to have_http_status :success
      end
    end

    context 'failed' do
      before do
        get :new, params: { client_clientname: client.clientname }
      end
      it 'should get new' do
        expect(response).to redirect_to sign_in_path
      end
    end
  end

  context 'post create' do
    let(:title) { '女性向けiphoneアプリ' }
    let(:content) { 'test' * 50 }
    let(:skills) { 'Ruby, HTML, css, C, PHP' }
    let(:note) { 'example ' * 10 }
    let(:start_date) { Date.new(2017, 5, 16) }
    let(:finish_date) { Date.new(2017, 9, 19) }
    context 'success' do
      before do
        sign_in_as(client_user)
      end
      it 'should create job content' do
        expect do
          post :create, params: { client_clientname: client.clientname, job_content: {
            title: title, content: content, skill_list: skills, note: note,
            start_date: start_date, finish_date: finish_date
          } }
        end
          .to change { JobContent.count }.by(1)
        expect(response).to redirect_to client_path(clientname: client.clientname)
        expect(flash).to be_present
      end
    end

    context 'failed' do
      context 'not signed in' do
        before do
          post :create, params: { client_clientname: client.clientname, job_content: {
            title: title, content: content, skill_list: skills, note: note,
            start_date: start_date, finish_date: finish_date
          } }
        end
        it { expect(response).to redirect_to sign_in_path }
      end

      context 'invalid information' do
        shared_examples_for 'invalid information of job contents' do
          before do
            sign_in_as(client_user)
          end
          it 'should not create job content' do
            expect do
              post :create, params: { client_clientname: client.clientname, job_content: {
                title: title, content: content, skill_list: skills, note: note,
                start_date: start_date, finish_date: finish_date
              } }
            end
              .to change { JobContent.count }.by(0)
            expect(response).to render_template :new
          end
        end

        context 'title' do
          it_behaves_like 'invalid information of job contents' do
            let(:title) { '' }
          end
        end

        context 'content' do
          it_behaves_like 'invalid information of job contents' do
            let(:title) { '' }
          end
        end

        context 'skill_list' do
          it_behaves_like 'invalid information of job contents' do
            let(:skills) { '' }
          end
        end

        context 'note' do
          it_behaves_like 'invalid information of job contents' do
            let(:note) { '' }
          end
        end

        context 'start_date' do
          it_behaves_like 'invalid information of job contents' do
            let(:start_date) { '' }
          end
        end

        context 'finish_date' do
          it_behaves_like 'invalid information of job contents' do
            let(:finish_date) { '' }
          end
        end
      end
    end
  end
end
