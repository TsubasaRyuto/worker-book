require 'rails_helper'

RSpec.describe ClientsController, type: :controller do
  let(:client) { create :client }
  let(:other_client) { create :other_client }
  let(:client_profile) { create :client_profile, client: client }

  describe 'get new' do
    context 'successfull' do
      before do
        get :new
      end
      it { expect(response).to have_http_status(:success) }
    end
  end

  describe 'post create' do
    let(:last_name) { Faker::Name.last_name }
    let(:first_name) { Faker::Name.first_name }
    let(:username) { 'example_client' }
    let(:com_name) { Faker::Company.name }
    let(:email) { 'client@example.com' }
    let(:password) { 'foobar123' }
    let(:confirmation) { 'foobar123' }
    context 'create valid client' do
      before do
        ApplicationMailer.deliveries.clear
      end

      it 'should create new client' do
        expect {
          post :create, params: { client: {
            last_name: last_name, first_name: first_name,
            username: username, company_name: com_name,
            email: email, password: password,
            password_confirmation: confirmation
          } }
        }.to change { Client.count }.by(1)
        expect(response).to redirect_to client_verify_email_url
        expect(ActionMailer::Base.deliveries.size).to eq(1)
        client = Client.find_by(email: 'client@example.com')
        expect(client.email).to eq('client@example.com')
        expect(client.authenticate('foobar123')).to be_truthy
      end
    end

    context 'create invalid client' do
      shared_examples_for 'invalid client' do
        it 'should not create client' do
          expect {
            post :create, params: { client: {
              last_name: last_name, first_name: first_name,
              username: username, email: email, password: password,
              password_confirmation: confirmation
            } }
          }.to change { Client.count }.by(0)
          expect(response).to render_template(:new)
        end
      end

      context 'invalid last_name' do
        it_behaves_like 'invalid client' do
          let(:last_name) { '' }
        end
      end

      context 'invalid first_name' do
        it_behaves_like 'invalid client' do
          let(:first_name) { '' }
        end
      end

      context 'invalid username' do
        it_behaves_like 'invalid client' do
          let(:username) { 'a+b' }
        end
      end

      context 'invalid email' do
        it_behaves_like 'invalid client' do
          let(:email) { 'user@example' }
        end
      end

      context 'invalid password' do
        it_behaves_like 'invalid client' do
          let(:password) { 'foobar' }
          let(:password_confirmation) { 'foobar' }
        end
      end

      context 'same username' do
        it_behaves_like 'invalid client' do
          let!(:old_client) { client }
          let(:username) { 'example_client' }
        end
      end

      context 'same email' do
        it_behaves_like 'invalid client' do
          let!(:old_client) { client }
          let(:email) { 'client@example.com' }
        end
      end
    end
  end
end
