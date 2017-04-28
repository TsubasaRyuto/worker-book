# == Schema Information
#
# Table name: clients
#
#  id                :integer          not null, primary key
#  last_name         :string(255)      not null
#  first_name        :string(255)      not null
#  username          :string(255)      not null
#  company_name      :string(255)      not null
#  email             :string(255)      not null
#  password_digest   :string(255)      not null
#  remember_digest   :string(255)
#  activation_digest :string(255)
#  activated         :boolean          default(FALSE), not null
#  activated_at      :datetime
#  reset_digest      :string(255)
#  reset_sent_at     :datetime
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#

require 'rails_helper'

RSpec.describe ClientsController, type: :controller do
  let(:client) { create :client }
  let(:other_client) { create :other_client }
  let(:client_profile) { create :client_profile, client: client }

  context 'get show' do
    before do
      client_profile
      get :show, params: { username: client.username }
    end
    it { expect(response).to have_http_status(:success) }
  end

  context 'get new' do
    context 'successfull' do
      before do
        get :new
      end
      it { expect(response).to have_http_status(:success) }
    end
  end

  context 'get edit' do
    context 'successfull' do
      before do
        sign_in_as(client)
        get :edit, params: { username: client.username }
      end
      it { expect(response).to have_http_status :success }
    end

    context 'not signed in client' do
      before do
        get :edit, params: { username: client.username }
      end
      it { expect(response).to redirect_to sign_in_url }
    end

    context 'not correct client' do
      before do
        sign_in_as(other_client)
        get :edit, params: { username: client.username }
      end
      it { expect(response).to redirect_to root_url }
    end
  end

  context 'get retire' do
    context 'successfull' do
      before do
        sign_in_as(client)
        get :retire, params: { username: client.username }
      end
      it { expect(response).to have_http_status :success }
    end

    context 'not signed in client' do
      before do
        get :retire, params: { username: client.username }
      end
      it { expect(response).to redirect_to sign_in_url }
    end

    context 'not correct client' do
      before do
        sign_in_as(other_client)
        get :retire, params: { username: client.username }
      end
      it { expect(response).to redirect_to root_url }
    end
  end

  context 'post create' do
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

  context 'patch update' do
    context 'successfull' do
      let(:username) { 'change_username' }
      let(:email) { 'change_email@example.com' }
      context 'update valid client' do
        before do
          sign_in_as(client)
          patch :update, params: { username: client.username, client: { username: username, email: email } }
        end

        it 'should update client info' do
          expect(response).to redirect_to client_url(username: username)
          client = Client.find_by(email: 'change_email@example.com')
          expect(client.email).to eq('change_email@example.com')
          expect(client.username).to eq('change_username')
        end
      end
    end

    context 'faild' do
      context 'not correct client' do
        let(:username) { 'change_username' }
        let(:email) { 'change_email@example.com' }
        before do
          sign_in_as(other_client)
          patch :update, params: { username: client.username, client: { username: username, email: email } }
        end
        it { expect(response).to redirect_to root_url }
      end

      context 'not signed in' do
        let(:username) { 'change_username' }
        let(:email) { 'change_email@example.com' }
        before do
          patch :update, params: { username: client.username, client: { username: username, email: email } }
        end
        it { expect(response).to redirect_to sign_in_url }
      end

      context 'invalid username' do
        let(:username) { '' }
        before do
          sign_in_as(client)
          patch :update, params: { username: client.username, client: { username: username } }
        end
        it { expect(response).to render_template :edit }
      end

      context 'invalid email' do
        let(:email) { '' }
        before do
          sign_in_as(client)
          patch :update, params: { username: client.username, client: { email: email } }
        end
        it { expect(response).to render_template :edit }
      end
    end
  end

  context '#destroy' do
    context 'successfull' do
      context 'update valid client' do
        before do
          sign_in_as(client)
        end

        it 'should delete account' do
          expect { delete :destroy, params: { username: client.username, password: client.password } }.to change { Client.count }.by(-1)
          expect(response).to redirect_to root_url
        end
      end
    end

    context 'faild' do
      context 'not correct client' do
        before do
          sign_in_as(other_client)
          delete :destroy, params: { username: client.username, password: client.password }
        end
        it { expect(response).to redirect_to root_url }
      end

      context 'not signed in' do
        before do
          delete :destroy, params: { username: client.username, password: client.password }
        end
        it { expect(response).to redirect_to sign_in_url }
      end

      context 'invalid password' do
        let(:password) { '' }
        before do
          sign_in_as(client)
          delete :destroy, params: { username: client.username, password: password }
        end
        it { expect(response).to render_template :retire }
      end
    end
  end
end
