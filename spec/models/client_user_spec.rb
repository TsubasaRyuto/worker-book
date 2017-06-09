require 'rails_helper'

RSpec.describe ClientUser, type: :model do
  let(:client) { create :client }
  let(:last_name) { Faker::Name.last_name }
  let(:first_name) { Faker::Name.first_name }
  let(:username) { 'example_client_user' }
  let(:email) { 'client_user@example.com' }
  let(:password) { 'foobar123' }
  let(:confirmation) { 'foobar123' }
  let(:client_user) { ClientUser.new(client: client, last_name: last_name, first_name: first_name, username: username, email: email, password: password, password_confirmation: confirmation) }

  context 'validates' do
    context 'successful' do
      it { expect(client_user).to be_valid }

      context 'valid any email' do
        let(:addresses) { %w(example@i.example.com foo+123@i.com foo-bar@EXAMPLE.COM foo_bar@example.NET) }
        it 'should be invalid' do
          addresses.each do |address|
            client_user.email = address
            expect(client_user).to be_valid
          end
        end
      end
    end

    context 'failed' do
      context 'last_name' do
        context 'present' do
          let(:last_name) { '' }
          it { expect(client_user).to be_invalid }
        end

        context 'too long' do
          let(:last_name) { 'a' * 31 }
          it { expect(client_user).to be_invalid }
        end
      end

      context 'first_name' do
        context 'present' do
          let(:first_name) { '' }
          it { expect(client_user).to be_invalid }
        end

        context 'too long' do
          let(:first_name) { 'a' * 31 }
          it { expect(client_user).to be_invalid }
        end
      end

      context 'username' do
        context 'present' do
          let(:username) { '' }
          it { expect(client_user).to be_invalid }
        end

        context 'too long' do
          let(:username) { 'a' * 31 }
          it { expect(client_user).to be_invalid }
        end

        context 'accept invalid username' do
          let(:invalid_usernames) { ['AA000', 'aa-bbb', 'aaaaa+b', 'aa.00', '///'] }
          it 'should be invalid' do
            invalid_usernames.each do |invalid_username|\
              client_user.username = invalid_username
              expect(client_user).to be_invalid
            end
          end
        end

        context 'unique client_user user' do
          let(:duplicate_client_user) { client_user.dup }
          before do
            duplicate_client_user.username = client_user.username.upcase
            client_user.save
          end
          it { expect(duplicate_client_user).to be_invalid }
        end

        context 'unique worker user' do
          let(:worker) { create :worker }
          let(:username) { 'example_worker' }
          before do
            worker
          end
          it { expect(client_user).to be_invalid }
        end
      end

      context 'email' do
        context 'present' do
          let(:email) { '' }
          it { expect(client_user).to be_invalid }
        end

        context 'too long' do
          let(:email) { 'a' * 90 + '@example.com' }
          it { expect(client_user).to be_invalid }
        end

        context 'accept invalid email' do
          let(:invalid_emails) { ['user@example', 'user@example,com', 'user@example+com', 'userexample.com', '+@+.com'] }
          it 'should be invalid' do
            invalid_emails.each do |invalid_email|
              client_user.email = invalid_email
              expect(client_user).to be_invalid
            end
          end
        end

        context 'unique client_user user' do
          let(:duplicate_client_user) { client_user.dup }
          before do
            duplicate_client_user.email = client_user.email.upcase
            client_user.save
          end
          it { expect(duplicate_client_user).to be_invalid }
        end

        context 'unique worker user' do
          let(:worker) { create :worker }
          let(:username) { 'worker@example.com' }
          before do
            worker
          end
          it { expect(client_user).to be_invalid }
        end
      end

      context 'password' do
        context 'present' do
          let(:password) { '' }
          it { expect(client_user).to be_invalid }
        end

        context 'too short' do
          let(:password) { 'a' * 7 }
          let(:confirmation) { 'a' * 7 }
          it { expect(client_user).to be_invalid }
        end
      end
    end
  end

  context '#remember' do
    context 'when worker remember' do
      let(:client_user) { create(:client_user, client: client) }
      before do
        client_user.remember
      end

      it 'is remember client_user' do
        expect(client_user.remember_digest).to be_present
        expect(client_user.remember_token).to be_present
      end
    end
  end

  context '#authenticated' do
    it 'authenticated? should return false for a client_user with nil digest' do
      expect(client_user).to_not be_authenticated(:remember, '')
    end
  end

  context '#forget' do
    context 'when forget client_user' do
      before do
        client_user.save
        client_user.remember
      end
      it 'is worget' do
        expect(client_user.remember_digest).to be_present
        client_user.forget
        expect(client_user.remember_digest).to be_blank
      end
    end
  end

  context '#activate' do
    let(:time_now) { Time.zone.local(2017, 1, 1, 0, 0, 0) }
    context 'when activate client_user' do
      before do
        client_user.save
        Timecop.freeze(time_now) do
          client_user.activate
        end
      end
      it 'is activatie' do
        expect(client_user.activated?).to be_truthy
        expect(client_user.activated_at).to be_present
        expect(client_user.activated_at).to eq time_now
      end
    end
  end

  context '#create_reset_digest' do
    context 'when create reset digest' do
      let(:time_now) { Time.zone.local(2016, 3, 7, 18, 0, 0) }
      before do
        client_user.save
        Timecop.freeze(time_now) do
          client_user.create_reset_digest
        end
      end
      it 'client_user have reset digest' do
        expect(client_user.reset_token).to be_present
        expect(client_user.reset_digest).to be_present
        expect(client_user.reset_sent_at).to be_present
        expect(client_user.reset_sent_at).to eq time_now
      end
    end
  end

  context '#password_reset_expired?' do
    context 'when password is reset' do
      before do
        client_user.save
        client_user.create_reset_digest
      end
      it 'client_user have not reset sent at' do
        expect(client_user.reset_sent_at).to be_present
        Timecop.travel(2.hours.from_now) do
          expect(client_user.password_reset_expired?).to be_truthy
        end
      end
    end
  end
end
