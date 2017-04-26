require 'rails_helper'

RSpec.describe Worker, type: :model do
  let(:last_name) { Faker::Name.last_name }
  let(:first_name) { Faker::Name.first_name }
  let(:username) { 'example_worker' }
  let(:email) { 'worker@example.com' }
  let(:password) { 'foobar123' }
  let(:confirmation) { 'foobar123' }
  let(:worker) { Worker.new(last_name: last_name, first_name: first_name, username: username, email: email, password: password, password_confirmation: confirmation) }

  context 'validates' do
    context 'successful' do
      it { expect(worker).to be_valid }

      context 'valid any email' do
        let(:addresses) { %w(example@i.example.com foo+123@i.com foo-bar@EXAMPLE.COM foo_bar@example.NET) }
        it 'should be invalid' do
          addresses.each do |address|
            worker.email = address
            expect(worker).to be_valid
          end
        end
      end
    end

    context 'failed' do
      context 'last_name' do
        context 'present' do
          let(:last_name) { '' }
          it { expect(worker).to be_invalid }
        end

        context 'too long' do
          let(:last_name) { 'a' * 31 }
          it { expect(worker).to be_invalid }
        end
      end

      context 'first_name' do
        context 'present' do
          let(:first_name) { '' }
          it { expect(worker).to be_invalid }
        end

        context 'too long' do
          let(:first_name) { 'a' * 31 }
          it { expect(worker).to be_invalid }
        end
      end

      context 'username' do
        context 'present' do
          let(:username) { '' }
          it { expect(worker).to be_invalid }
        end

        context 'too long' do
          let(:username) { 'a' * 31 }
          it { expect(worker).to be_invalid }
        end

        context 'accept invalid username' do
          let(:invalid_usernames) { ['AA000', 'aa-bbb', 'aaaaa+b', 'aa.00', '///'] }
          it 'should be invalid' do
            invalid_usernames.each do |invalid_username|\
              worker.username = invalid_username
              expect(worker).to be_invalid
            end
          end
        end

        context 'unique' do
          let(:duplicate_worker) { worker.dup }
          before do
            duplicate_worker.username = worker.username.upcase
            worker.save
          end
          it { expect(duplicate_worker).to be_invalid }
        end
      end

      context 'email' do
        context 'present' do
          let(:email) { '' }
          it { expect(worker).to be_invalid }
        end

        context 'too long' do
          let(:email) { 'a' * 90 + '@example.com' }
          it { expect(worker).to be_invalid }
        end

        context 'accept invalid email' do
          let(:invalid_emails) { ['user@example', 'user@example,com', 'user@example+com', 'userexample.com', '+@+.com'] }
          it 'should be invalid' do
            invalid_emails.each do |invalid_email|
              worker.email = invalid_email
              expect(worker).to be_invalid
            end
          end
        end

        context 'unique' do
          let(:duplicate_worker) { worker.dup }
          before do
            duplicate_worker.email = worker.email.upcase
            worker.save
          end
          it { expect(duplicate_worker).to be_invalid }
        end
      end

      context 'password' do
        context 'present' do
          let(:password) { '' }
          it { expect(worker).to be_invalid }
        end

        context 'too short' do
          let(:password) { 'a' * 7 }
          let(:confirmation) { 'a' * 7 }
          it { expect(worker).to be_invalid }
        end
      end
    end
  end

  context '#remember' do
    context 'when worker remember' do
      let(:worker) { create(:worker) }
      before do
        worker.remember
      end

      it 'is remember worker' do
        expect(worker.remember_digest).to be_present
        expect(worker.remember_token).to be_present
      end
    end
  end

  context '#authenticated' do
    it 'authenticated? should return false for a worker with nil digest' do
      expect(worker).to_not be_authenticated(:remember, '')
    end
  end

  context '#forget' do
    context 'when forget worker' do
      before do
        worker.save
        worker.remember
      end
      it 'is worget' do
        expect(worker.remember_digest).to be_present
        worker.forget
        expect(worker.remember_digest).to be_blank
      end
    end
  end

  context '#activate' do
    let(:time_now) { Time.zone.local(2017, 1, 1, 0, 0, 0) }
    context 'when activate worker' do
      before do
        worker.save
        Timecop.freeze(time_now) do
          worker.activate
        end
      end
      it 'is activatie' do
        expect(worker.activated?).to be_truthy
        expect(worker.activated_at).to be_present
        expect(worker.activated_at).to eq time_now
      end
    end
  end

  context '#create_reset_digest' do
    context 'when create reset digest' do
      let(:time_now) { Time.zone.local(2016, 3, 7, 18, 0, 0) }
      before do
        worker.save
        Timecop.freeze(time_now) do
          worker.create_reset_digest
        end
      end
      it 'worker have reset digest' do
        expect(worker.reset_token).to be_present
        expect(worker.reset_digest).to be_present
        expect(worker.reset_sent_at).to be_present
        expect(worker.reset_sent_at).to eq time_now
      end
    end
  end

  context '#password_reset_expired?' do
    context 'when password is reset' do
      before do
        worker.save
        worker.create_reset_digest
      end
      it 'worker have not reset sent at' do
        expect(worker.reset_sent_at).to be_present
        Timecop.travel(2.hours.from_now) do
          expect(worker.password_reset_expired?).to be_truthy
        end
      end
    end
  end
end
