require 'rails_helper'

RSpec.describe SessionsController, type: :controller do
  context 'get new' do
    context 'successfull' do
      before do
        get :new
      end
      it { expect(response).to have_http_status(:success) }
    end
  end

  context 'post create' do
    context 'successfull' do
      shared_examples_for 'successfull sign in user' do
        context 'remember_me on' do
          before do
            user_profile
            post :create, params: { session: { email: user.email, password: user.password, remember_me: '1' } }
          end
          it 'should user sign in' do
            expect(response).to redirect_to redirect_url
            expect(signed_in?).to be_truthy
            expect(cookies['remember_token']).to be_present
          end
        end

        context 'remember_me off' do
          before do
            user_profile
            post :create, params: { session: { email: user.email, password: user.password, remember_me: '0' } }
          end
          it 'should user sign in' do
            expect(response).to redirect_to redirect_url
            expect(signed_in?).to be_truthy
            expect(cookies['remember_token']).to be_blank
          end
        end
      end

      context 'worker' do
        it_behaves_like 'successfull sign in user' do
          let(:user) { create :worker }
          let(:user_profile) { create :worker_profile, worker: user }
          let(:redirect_url) {"/worker/#{user.username}"}
        end

        context 'successfull sign in, but not create user profile' do
          let(:user) { create :worker }
          before do
            post :create, params: { session: { email: user.email, password: user.password, remember_me: '1' } }
          end
          it 'should user sign in' do
            expect(response).to redirect_to "/#{user_type(user)}/#{user.username}/create_profile"
            expect(signed_in?).to be_truthy
            expect(cookies['remember_token']).to be_present
          end
        end
      end

      context 'client' do
        it_behaves_like 'successfull sign in user' do
          let(:user_profile) { create :client }
          let(:user) { create :client_user, client: user_profile }
          let(:redirect_url) {"/client/#{user_profile.clientname}"}
        end
      end
    end

    context 'failed' do
      shared_examples_for 'valid information & invalid account activation' do
        before do
          user_profile
          post :create, params: { session: { email: user.email, password: user.password, remember_me: '0' } }
        end
        it 'should not user sign in' do
          expect(response).to redirect_to root_url
          expect(flash).to be_present
          expect(signed_in?).to be_falsey
        end
      end

      shared_examples_for 'invalid information' do
        before do
          user_profile
          post :create, params: { session: { email: user.email } }
        end
        it 'should not user sign in' do
          expect(response).to render_template :new
          expect(signed_in?).to be_falsey
          expect(flash).to be_present
        end
      end

      context 'worker' do
        it_behaves_like 'valid information & invalid account activation' do
          let(:user) { create :worker, activated: false, activated_at: nil }
          let(:user_profile) { create :worker_profile, worker: user }
        end

        it_behaves_like 'invalid information' do
          let(:user) { create :worker }
          let(:user_profile) { create :worker_profile, worker: user }
        end
      end

      context 'client' do
        it_behaves_like 'valid information & invalid account activation' do
          let(:user_profile) { create :client }
          let(:user) { create :client_user, client: user_profile, activated: false, activated_at: nil }
        end

        it_behaves_like 'invalid information' do
          let(:user_profile) { create :client }
          let(:user) { create :client_user, client: user_profile }
        end
      end
    end
  end

  context 'get destroy' do
    before do
      get :destroy
    end
    it 'should user log out' do
      expect(response).to redirect_to root_url
      expect(signed_in?).to be_falsey
    end
  end
end
