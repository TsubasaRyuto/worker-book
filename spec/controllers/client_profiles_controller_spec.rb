require 'rails_helper'

RSpec.describe ClientProfilesController, truncation: true, type: :controller do
  let(:client) { create :client }
  let(:client_profile) { create :client_profile, client: client }

  context 'get new' do
    context 'success' do
      before do
        sign_in_as(client)
        get :new, params: { client_username: client.username }
      end
      it 'should get new' do
        expect(response).to have_http_status :success
        expect(signed_in?).to be_truthy
        expect(client.activated).to be_truthy
      end
    end

    context 'failed' do
      context 'with not signed in' do
        before do
          get :new, params: { client_username: client.username }
        end
        it 'should redirect to root' do
          expect(response).to redirect_to sign_in_url
          expect(signed_in?).to be_falsey
        end
      end
    end
  end

  context 'get edit' do
    context 'success' do
      before do
        client_profile
        sign_in_as(client)
        get :edit, params: { client_username: client.username }
      end
      it 'should get edit' do
        expect(response).to have_http_status :success
        expect(signed_in?).to be_truthy
        expect(client.activated).to be_truthy
      end
    end

    context 'failed' do
      context 'with not signed in' do
        before do
          client_profile
          get :edit, params: { client_username: client.username }
        end
        it 'should redirect to root' do
          expect(response).to redirect_to sign_in_url
          expect(signed_in?).to be_falsey
        end
      end
    end
  end

  context 'post create' do
    let(:logo) { fixture_file_upload('images/lobo.png', 'image/png') }
    let(:com_url) { 'http://example.com' }
    before do
      sign_in_as(client)
    end
    context 'successful' do
      it 'should create client profile' do
        expect { post :create, params: { client_username: client.username, client_profile: { logo: logo, corporate_site: com_url } } }.to change { ClientProfile.count }.by(1)
        expect(response).to redirect_to client_url(username: client.username)
        expect(flash).to be_present
      end
    end

    context 'failed' do
      shared_examples_for 'invalid profile information' do
        before do
          post :create, params: { client_username: client.username, client_profile: { logo: logo, corporate_site: com_url } }
        end
        it 'should not create client profile' do
          expect(response).to render_template :new
        end
      end

      context 'invalid logo' do
        it_behaves_like 'invalid profile information' do
          let(:logo) { '' }
        end
      end

      context 'invalid corporate_site' do
        it_behaves_like 'invalid profile information' do
          let(:com_url) { '' }
        end
      end
    end
  end

  context 'patch update' do
    let(:logo) { fixture_file_upload('images/lobo.png', 'image/png') }
    let(:com_url) { 'http://example1.com' }
    before do
      client_profile
      sign_in_as(client)
      patch :update, params: { client_username: client.username, client_profile: { logo: logo, corporate_site: com_url } }
    end

    context 'successful' do
      it 'should update client profile' do
        expect(response).to redirect_to client_url(username: client.username)
        expect(flash).to be_present
        client_profile.reload
        expect(client_profile.corporate_site).to eq('http://example1.com')
      end
    end

    context 'failed' do
      shared_examples_for 'invalid profile information' do
        it 'should not create client profile' do
          expect(response).to render_template :edit
        end
      end

      context 'invalid logo' do
        it_behaves_like 'invalid profile information' do
          let(:logo) { '' }
        end
      end

      context 'invalid corporate_site' do
        it_behaves_like 'invalid profile information' do
          let(:com_url) { '' }
        end
      end
    end
  end
end
