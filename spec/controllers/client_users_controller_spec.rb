# == Schema Information
#
# Table name: client_users
#
#  id                :integer          not null, primary key
#  client_id         :integer          not null
#  last_name         :string(255)      not null
#  first_name        :string(255)      not null
#  username          :string(255)      not null
#  email             :string(255)      not null
#  user_type         :integer          default("admin")
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
# Indexes
#
#  index_client_users_on_client_id  (client_id)
#

require 'rails_helper'

RSpec.describe ClientUsersController, type: :controller do
  let(:client) { create :client }
  let(:client_user) { create :client_user, client: client }
  let(:other_client_user) { create :other_client_user, client: client }

  context 'get edit' do
    context 'successfull' do
      before do
        sign_in_as(client_user)
        get :edit, params: { client_clientname: client.clientname, username: client_user.username }
      end
      it { expect(response).to have_http_status :success }
    end

    context 'not signed in client_user' do
      before do
        get :edit, params: { client_clientname: client.clientname, username: client_user.username }
      end
      it { expect(response).to redirect_to sign_in_url }
    end

    context 'not correct client_user' do
      before do
        sign_in_as(other_client_user)
        get :edit, params: { client_clientname: client.clientname, username: client_user.username }
      end
      it { expect(response).to redirect_to root_url }
    end
  end

  context 'get retire' do
    context 'successfull' do
      before do
        sign_in_as(client_user)
        get :retire, params: { client_clientname: client.clientname, username: client_user.username }
      end
      it { expect(response).to have_http_status :success }
    end

    context 'not signed in client_user' do
      before do
        get :retire, params: { client_clientname: client.clientname, username: client_user.username }
      end
      it { expect(response).to redirect_to sign_in_url }
    end

    context 'not correct client_user' do
      before do
        sign_in_as(other_client_user)
        get :retire, params: { client_clientname: client.clientname, username: client_user.username }
      end
      it { expect(response).to redirect_to root_url }
    end
  end

  context 'patch update' do
    context 'successfull' do
      let(:username) { 'change_username' }
      let(:email) { 'change_email@example.com' }
      context 'update valid client_user' do
        before do
          sign_in_as(client_user)
          patch :update, params: { client_clientname: client.clientname, username: client_user.username, client_user: { username: username, email: email } }
        end

        it 'should update client_user info' do
          expect(response).to redirect_to client_url(clientname: client.clientname)
          client_user = ClientUser.find_by(email: 'change_email@example.com')
          expect(client_user.email).to eq('change_email@example.com')
          expect(client_user.username).to eq('change_username')
        end
      end
    end

    context 'faild' do
      context 'not correct client_user' do
        let(:username) { 'change_username' }
        let(:email) { 'change_email@example.com' }
        before do
          sign_in_as(other_client_user)
          patch :update, params: { client_clientname: client.clientname, username: client_user.username, client_user: { username: username, email: email } }
        end
        it { expect(response).to redirect_to root_url }
      end

      context 'not signed in' do
        let(:username) { 'change_username' }
        let(:email) { 'change_email@example.com' }
        before do
          patch :update, params: { client_clientname: client.clientname, username: client_user.username, client_user: { username: username, email: email } }
        end
        it { expect(response).to redirect_to sign_in_url }
      end

      context 'invalid username' do
        let(:username) { '' }
        before do
          sign_in_as(client_user)
          patch :update, params: { client_clientname: client.clientname, username: client_user.username, client_user: { username: username } }
        end
        it { expect(response).to render_template :edit }
      end

      context 'invalid email' do
        let(:email) { '' }
        before do
          sign_in_as(client_user)
          patch :update, params: { client_clientname: client.clientname, username: client_user.username, client_user: { email: email } }
        end
        it { expect(response).to render_template :edit }
      end
    end
  end

  context '#destroy' do
    context 'successfull' do
      context 'update valid client_user' do
        before do
          sign_in_as(client_user)
        end

        it 'should delete account' do
          expect { delete :destroy, params: { client_clientname: client.clientname, username: client_user.username, password: client_user.password } }.to change { ClientUser.count }.by(-1).and change { Client.count }.by(-1)
          expect(response).to redirect_to root_url
        end
      end
    end

    context 'faild' do
      context 'not correct client_user' do
        before do
          sign_in_as(other_client_user)
          delete :destroy, params: { client_clientname: client.clientname, username: client_user.username, password: client_user.password }
        end
        it { expect(response).to redirect_to root_url }
      end

      context 'not signed in' do
        before do
          delete :destroy, params: { client_clientname: client.clientname, username: client_user.username, password: client_user.password }
        end
        it { expect(response).to redirect_to sign_in_url }
      end

      context 'invalid password' do
        let(:password) { '' }
        before do
          sign_in_as(client_user)
          delete :destroy, params: { client_clientname: client.clientname, username: client_user.username, password: password }
        end
        it { expect(response).to render_template :retire }
      end
    end
  end
end
