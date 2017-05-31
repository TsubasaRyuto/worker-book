require 'rails_helper'

RSpec.describe Chat, type: :model do
  let(:worker) { create :worker }
  let(:client) { create :client }
  let(:client_user) { create :client_user, client: client }
  let(:job_content) { create :job_content, client: client }
  let(:agreement) { create :agreement, job_content: job_content, worker: worker }

  let(:message) { 'test' }
  let(:receiver_username) { worker.username }
  let(:sender_username) { client_user.username }

  let(:chat) { agreement.chats.new(message: message, sender_username: sender_username, receiver_username: receiver_username) }

  context 'validates' do
    before do
      Timecop.travel(Date.new(2017, 01, 01)) do
        job_content
        agreement
      end
    end
    context 'successful' do
      it { expect(chat).to be_valid }
    end

    context 'failed' do
      context 'message' do
        context 'present' do
          let(:message) { '' }
          it { expect(chat).to be_invalid }
        end

        context 'maximum' do
          let(:message) { 'a' * 3001 }
          it { expect(chat).to be_invalid }
        end
      end

      context 'receiver username' do
        context 'present' do
          let(:receiver_username) { '' }
          it { expect(chat).to be_invalid }
        end
      end

      context 'sender username' do
        context 'present' do
          let(:sender_username) { '' }
          it { expect(chat).to be_invalid }
        end
      end
    end
  end
end
