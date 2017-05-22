# == Schema Information
#
# Table name: chats
#
#  id                :integer          not null, primary key
#  agreement_id      :integer
#  sender_username   :string(255)      not null
#  receiver_username :string(255)      not null
#  message           :text(65535)      not null
#  read_flg          :boolean          default(FALSE), not null
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#
# Indexes
#
#  index_chats_on_agreement_id  (agreement_id)
#

require 'rails_helper'

RSpec.describe ChatsController, type: :controller do
  let(:client) { create :client }
  let(:client_user) { create :client_user, client: client }
  let(:job_content) { create :job_content, client: client }
  let(:worker) { create :worker }
  let(:agreement) { create :agreement, job_content: job_content, worker: worker }
  let(:other_worker) { create :other_worker }
  let(:other_client) { create :other_client }
  let(:other_client_user) { create :other_client_user, client: other_client }
  context 'get show' do
    shared_examples_for 'redirect to show' do
      context 'successfull' do
        before do
          Timecop.travel(Date.new(2017,01,01)) do
            job_content
            agreement
          end
          sign_in_as(signed_user)
          get :show, params: { partner_username: partner_username }
        end
        it { expect(response).to have_http_status :success }
      end

      context 'faild' do
        context 'not sign' do
          before do
            Timecop.travel(Date.new(2017,01,01)) do
              job_content
              agreement
            end
            get :show, params: { partner_username: partner_username }
          end
          it { expect(response).to redirect_to sign_in_path }
        end

        context 'invalid agreement chat' do
          before do
            Timecop.travel(Date.new(2017,01,01)) do
              job_content
              agreement
            end
            sign_in_as(signed_user)
            get :show, params: { partner_username: other_partner_name }
          end
          it { expect(response).to redirect_to '/chat/messages/@notification' }
        end
      end
    end

    context 'worker' do
      it_behaves_like 'redirect to show' do
        let(:signed_user) { client_user }
        let(:partner_username) { worker.username }
        let(:other_partner_name) { other_worker.username }
      end
    end

    context 'client user' do
      it_behaves_like 'redirect to show' do
        let(:signed_user) { worker }
        let(:partner_username) { client_user.username }
        let(:other_partner_name) { other_client_user.username }
      end
    end
  end
end
