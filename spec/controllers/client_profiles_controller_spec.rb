# == Schema Information
#
# Table name: client_profiles
#
#  id             :integer          not null, primary key
#  corporate_site :string(255)      not null
#  logo           :string(255)      not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
# Indexes
#
#  index_client_profiles_on_id  (id) UNIQUE
#

require 'rails_helper'

RSpec.describe ClientProfilesController, type: :controller do
  let(:client) { create :client }
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
          expect(response).to redirect_to root_url
          expect(signed_in?).to be_falsey
        end
      end

      context 'with not activated' do
        let(:activated) { false }
        before do
          client.activated = activated
          get :new, params: { client_username: client.username }
        end
        it 'should redirect to root' do
          expect(response).to redirect_to root_url
          expect(signed_in?).to be_falsey
        end
      end
    end
  end

  context 'post create' do
    let(:com_url) { 'http://example.com' }
    let(:logo) { fixture_file_upload('images/lobo.png', 'image/png') }
    before do
      sign_in_as(client)
    end
    context 'success' do
      it 'should be create client profile' do
        expect do
          post :create, params: { client_username: client.username, client_profile: { corporate_site: com_url, logo: logo } }
        end
          .to change { ClientProfile.count }.by(1)
        expect(response).to redirect_to client_url(username: client.username)
        expect(flash).to be_present
      end
    end

    context 'failed with invalid information' do
      shared_examples_for 'invalid profile information' do
        before do
          post :create, params: { client_username: client.username, client_profile: { corporate_site: com_url, logo: logo } }
        end
        it 'should not create client profile' do
          expect(response).to render_template :new
        end
      end

      context 'invalid corporate site' do
        context 'empty' do
          it_behaves_like 'invalid profile information' do
            let(:com_url) { '' }
          end
        end

        context 'invalid format' do
          it_behaves_like 'invalid profile information' do
            let(:com_url) { '//http://exmaple.com' }
          end
        end

        context 'not uniqueness' do
          let!(:old_client) { create :other_client }
          let!(:old_client_profile) { create :client_profile, client: old_client }
          it_behaves_like 'invalid profile information' do
            let(:com_url) { 'http://example.com' }
          end
        end
      end

      context 'invalid logo' do
        context 'empty' do
          it_behaves_like 'invalid profile information' do
            let(:logo) { '' }
          end
        end
      end
    end
  end
end
