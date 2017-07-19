require 'rails_helper'

RSpec.describe InquiriesController, type: :controller do
  let(:name) { Faker::Name.name }
  let(:email) { 'test_user@example.com' }
  let(:inquiry_title) { 'テストタイトル' }
  let(:message) { Faker::Lorem.sentence }
  context 'get index' do
    context 'success' do
      before do
        get :index
      end
      it { expect(response).to have_http_status :success }
    end
  end

  context 'post confirm' do
    context 'success' do
      before do
        post :confirm, params: { inquiry: { name: name, email: email, inquiry_title: inquiry_title, message: message } }
      end
      it { expect(response).to render_template :confirm }
    end

    context 'faild' do
      before do
        post :confirm, params: { inquiry: { name: name, email: email, inquiry_title: inquiry_title, message: nil } }
      end
      it { expect(response).to render_template :index }
    end
  end

  context 'post thanks' do
    context 'success' do
      before do
        post :thanks, params: { inquiry: { name: name, email: email, inquiry_title: inquiry_title, message: message } }
      end
      it 'should send inquiry' do
        expect(response).to render_template :thanks
        expect(ActionMailer::Base.deliveries.size).to eq(2)
      end
    end
  end
end
