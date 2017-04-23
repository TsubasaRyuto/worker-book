require 'rails_helper'

RSpec.describe Client, type: :model do
  let(:last_name) { Faker::Name.last_name }
  let(:first_name) { Faker::Name.first_name }
  let(:username) { 'example_client' }
  let(:com_name) { 'example株式会社' }
  let(:email) { 'client@example.com' }
  let(:password) { 'foobar123' }
  let(:confirmation) { 'foobar123' }
  let(:client) { Client.new(last_name: last_name, first_name: first_name, username: username, company_name: com_name, email: email, password: password, password_confirmation: confirmation) }

  describe 'validates' do
    context 'successful' do
      it { expect(client).to be_valid }

      context 'valid any email' do
        let(:addresses) { %w(example@i.example.com foo+123@i.com foo-bar@EXAMPLE.COM foo_bar@example.NET) }
        it 'should be invalid' do
          addresses.each do |address|
            client.email = address
            expect(client).to be_valid
          end
        end
      end
    end

    context 'failed' do
      context 'last_name' do
        context 'present' do
          let(:last_name) { '' }
          it { expect(client).to be_invalid }
        end

        context 'too long' do
          let(:last_name) { 'a' * 31 }
          it { expect(client).to be_invalid }
        end
      end

      context 'first_name' do
        context 'present' do
          let(:first_name) { '' }
          it { expect(client).to be_invalid }
        end

        context 'too long' do
          let(:first_name) { 'a' * 31 }
          it { expect(client).to be_invalid }
        end
      end

      context 'username' do
        context 'present' do
          let(:username) { '' }
          it { expect(client).to be_invalid }
        end

        context 'too long' do
          let(:username) { 'a' * 31 }
          it { expect(client).to be_invalid }
        end

        context 'accept invalid username' do
          let(:invalid_usernames) { ['AA000', 'aa-bbb', 'aaaaa+b', 'aa.00', '///'] }
          it 'should be invalid' do
            invalid_usernames.each do |invalid_username|\
              client.username = invalid_username
              expect(client).to be_invalid
            end
          end
        end

        context 'unique client user' do
          let(:duplicate_client) { client.dup }
          before do
            duplicate_client.username = client.username.upcase
            client.save
          end
          it { expect(duplicate_client).to be_invalid }
        end

        context 'unique worker user' do
          let(:worker) { create :worker }
          let(:username) { 'example_worker' }
          before do
            worker
          end
          it { expect(client).to be_invalid }
        end
      end

      context 'email' do
        context 'present' do
          let(:email) { '' }
          it { expect(client).to be_invalid }
        end

        context 'too long' do
          let(:email) { 'a' * 90 + '@example.com' }
          it { expect(client).to be_invalid }
        end

        context 'accept invalid email' do
          let(:invalid_emails) { ['user@example', 'user@example,com', 'user@example+com', 'userexample.com', '+@+.com'] }
          it 'should be invalid' do
            invalid_emails.each do |invalid_email|
              client.email = invalid_email
              expect(client).to be_invalid
            end
          end
        end

        context 'unique client user' do
          let(:duplicate_client) { client.dup }
          before do
            duplicate_client.email = client.email.upcase
            client.save
          end
          it { expect(duplicate_client).to be_invalid }
        end

        context 'unique worker user' do
          let(:worker) { create :worker }
          let(:username) { 'worker@example.com' }
          before do
            worker
          end
          it { expect(client).to be_invalid }
        end
      end

      context 'password' do
        context 'present' do
          let(:password) { '' }
          it { expect(client).to be_invalid }
        end

        context 'too short' do
          let(:password) { 'a' * 7 }
          let(:confirmation) { 'a' * 7 }
          it { expect(client).to be_invalid }
        end
      end
    end
  end
end
