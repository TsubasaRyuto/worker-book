# == Schema Information
#
# Table name: clients
#
#  id             :integer          not null, primary key
#  name           :string(255)      not null
#  corporate_site :string(255)      not null
#  clientname     :string(255)      not null
#  location       :string(255)      default("01"), not null
#  logo           :string(255)      not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

require 'rails_helper'

RSpec.describe ClientsController, truncation: true, type: :controller do
  let(:client) { create :client }
  let(:client_user) { create :client_user, client: client }

  context 'get show' do
    context 'success' do
      before do
        sign_in_as(client_user)
        get :show, params: { clientname: client.clientname }
      end
      it { expect(response).to have_http_status :success }
    end

    context 'failed' do
      before do
        get :show, params: { clientname: client.clientname }
      end
      it { expect(response).to redirect_to sign_in_url }
    end
  end

  context 'get new' do
    context 'success' do
      before do
        get :new
      end
      it 'should get new' do
        expect(response).to have_http_status :success
      end
    end
  end

  context 'get edit' do
    context 'success' do
      before do
        sign_in_as(client_user)
        get :edit, params: { clientname: client.clientname }
      end
      it 'should get edit' do
        expect(response).to have_http_status :success
        expect(signed_in?).to be_truthy
        expect(client_user.activated).to be_truthy
      end
    end

    context 'failed' do
      context 'with not signed in' do
        before do
          get :edit, params: { clientname: client.clientname }
        end
        it 'should redirect to root' do
          expect(response).to redirect_to sign_in_url
          expect(signed_in?).to be_falsey
        end
      end
    end
  end

  context 'post create' do
    let(:com_name) { Faker::Company.name }
    let(:logo) { fixture_file_upload('images/lobo.png', 'image/png') }
    let(:com_url) { 'http://example.com' }
    let(:clientname) { 'examplename' }
    let(:location) { '02' }

    let(:last_name) { Faker::Name.last_name }
    let(:first_name) { Faker::Name.first_name }
    let(:username) { 'example_client_user' }
    let(:email) { 'client@example.com' }
    let(:password) { 'foobar123' }
    let(:confirmation) { 'foobar123' }

    before do
      ApplicationMailer.deliveries.clear
    end

    context 'successful' do
      it 'should create client profile' do
        expect {
          post :create, params: { client: {
            logo: logo, corporate_site: com_url, name: com_name,
            clientname: clientname, location: location,
            client_users_attributes: { :"0" => {
              last_name: last_name, first_name: first_name,
              username: username, email: email, password: password,
              password_confirmation: confirmation
            } }
          } }
        }.to change { Client.count }.by(1).and change { ClientUser.count }.by(1)
        expect(ActionMailer::Base.deliveries.size).to eq(1)
        expect(response).to redirect_to client_verify_email_url
        client_user = ClientUser.find_by(email: 'client@example.com')
        expect(client_user.email).to eq('client@example.com')
        expect(client_user.authenticate('foobar123')).to be_truthy
      end
    end

    context 'failed' do
      shared_examples_for 'invalid information as create' do
        it 'should not create client account' do
          expect {
            post :create, params: { client: {
              logo: logo, corporate_site: com_url, name: com_name,
              clientname: clientname, location: location,
              client_users_attributes: { :"0" => {
                last_name: last_name, first_name: first_name,
                username: username, email: email, password: password,
                password_confirmation: confirmation
              } }
            } }
          }.to change { Client.count }.by(0).and change { ClientUser.count }.by(0)
          expect(response).to render_template(:new)
        end
      end

      context 'invalid logo' do
        it_behaves_like 'invalid information as create' do
          let(:logo) { '' }
        end
      end

      context 'invalid name' do
        it_behaves_like 'invalid information as create' do
          let(:com_name) { '' }
        end
      end

      context 'invalid corporate_site' do
        it_behaves_like 'invalid information as create' do
          let(:com_url) { '' }
        end
      end

      context 'invalid clientname' do
        it_behaves_like 'invalid information as create' do
          let(:clientname) { '' }
        end
      end

      context 'invalid location' do
        it_behaves_like 'invalid information as create' do
          let(:location) { '' }
        end
      end

      context 'invalid corporate_site' do
        it_behaves_like 'invalid information as create' do
          let(:com_url) { '' }
        end
      end

      context 'invalid last_name' do
        it_behaves_like 'invalid information as create' do
          let(:last_name) { '' }
        end
      end

      context 'invalid first_name' do
        it_behaves_like 'invalid information as create' do
          let(:first_name) { '' }
        end
      end

      context 'invalid username' do
        it_behaves_like 'invalid information as create' do
          let(:username) { 'a+b' }
        end
      end

      context 'invalid email' do
        it_behaves_like 'invalid information as create' do
          let(:email) { 'user@example' }
        end
      end

      context 'invalid password' do
        it_behaves_like 'invalid information as create' do
          let(:password) { 'foobar' }
          let(:password_confirmation) { 'foobar' }
        end
      end
    end
  end

  context 'patch update' do
    let(:com_name) { Faker::Company.name }
    let(:logo) { fixture_file_upload('images/lobo.png', 'image/png') }
    let(:com_url) { 'http://example1.com' }
    let(:clientname) { 'examplename' }
    let(:location) { 02 }
    before do
      sign_in_as(client_user)
      patch :update, params: { clientname: client.clientname, client: {
        logo: logo, corporate_site: com_url, name: com_name,
        clientname: clientname, location: location
      } }
    end

    context 'successful' do
      it 'should update client profile' do
        client.reload
        expect(response).to redirect_to client_url(clientname: client.clientname)
        expect(flash).to be_present
        expect(client.corporate_site).to eq('http://example1.com')
      end
    end

    context 'failed' do
      shared_examples_for 'invalid information as update' do
        it 'should not create client account' do
          expect(response).to render_template :edit
        end
      end

      context 'invalid logo' do
        it_behaves_like 'invalid information as update' do
          let(:logo) { '' }
        end
      end
    end
  end
end
