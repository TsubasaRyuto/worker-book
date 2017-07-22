require 'rails_helper'

RSpec.describe Inquiry, type: :model do
  let(:name) { Faker::Name.name }
  let(:email) { 'test_user@example.com' }
  let(:inquiry_title) { 'テストタイトル' }
  let(:message) { 'お問い合わせ' }
  let(:inquiry) { Inquiry.new(name: name, email: email, inquiry_title: inquiry_title, message: message) }
  context 'validates' do
    context 'successful' do
      it { expect(inquiry).to be_valid }

      context 'valid any email' do
        let(:addresses) { %w(example@i.example.com foo+123@i.com foo-bar@EXAMPLE.COM foo_bar@example.NET) }
        it 'should be invalid' do
          addresses.each do |address|
            inquiry.email = address
            expect(inquiry).to be_valid
          end
        end
      end
    end

    context 'failed' do
      context 'name' do
        context 'present' do
          let(:name) { '' }
          it { expect(inquiry).to be_invalid }
        end

        context 'too long' do
          let(:name) { 'a' * 31 }
          it { expect(inquiry).to be_invalid }
        end
      end

      context 'email' do
        context 'present' do
          let(:email) { '' }
          it { expect(inquiry).to be_invalid }
        end

        context 'too long' do
          let(:email) { 'a' * 90 + '@example.com' }
          it { expect(inquiry).to be_invalid }
        end

        context 'accept invalid email' do
          let(:invalid_emails) { ['user@example', 'user@example,com', 'user@example+com', 'userexample.com', '+@+.com'] }
          it 'should be invalid' do
            invalid_emails.each do |invalid_email|
              inquiry.email = invalid_email
              expect(inquiry).to be_invalid
            end
          end
        end
      end

      context 'inquiry_title' do
        context 'present' do
          let(:inquiry_title) { '' }
          it { expect(inquiry).to be_invalid }
        end

        context 'too long' do
          let(:inquiry_title) { 'a' * 31 }
          it { expect(inquiry).to be_invalid }
        end
      end

      context 'message' do
        context 'present' do
          let(:message) { '' }
          it { expect(inquiry).to be_invalid }
        end

        context 'too long' do
          let(:message) { 'a' * 3001 }
          it { expect(inquiry).to be_invalid }
        end
      end
    end
  end
end
