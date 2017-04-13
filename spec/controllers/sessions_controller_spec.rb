require 'rails_helper'

RSpec.describe SessionsController, type: :controller do
  let(:worker) { create :worker }
  let(:worker_profile) { create :worker_profile, worker: worker }
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
      context 'remember_me on' do
        before do
          worker_profile
          post :create, params: { session: { email: worker.email, password: worker.password, remember_me: '1' } }
        end
        it 'should worker sign in' do
          expect(response).to redirect_to worker_url(username: worker.username)
          expect(signed_in?).to be_truthy
          expect(cookies['remember_token']).to be_present
        end
      end

      context 'remember_me off' do
        before do
          worker_profile
          post :create, params: { session: { email: worker.email, password: worker.password, remember_me: '0' } }
        end
        it 'should worker sign in' do
          expect(response).to redirect_to worker_url(username: worker.username)
          expect(signed_in?).to be_truthy
          expect(cookies['remember_token']).to be_blank
        end
      end

      context 'successfull sign in, but not create worker profile' do
        before do
          post :create, params: { session: { email: worker.email, password: worker.password, remember_me: '1' } }
        end
        it 'should worker sign in' do
          expect(response).to redirect_to worker_create_profile_path(worker_username: worker.username)
          expect(signed_in?).to be_truthy
          expect(cookies['remember_token']).to be_present
        end
      end
    end

    context 'failed' do
      context 'valid information & invalid account activation' do
        let(:worker) { create :worker, activated: false, activated_at: nil }
        before do
          worker_profile
          post :create, params: { session: { email: worker.email, password: worker.password, remember_me: '0' } }
        end
        it 'should not worker sign in' do
          expect(response).to redirect_to root_url
          expect(flash).to be_present
          expect(signed_in?).to be_falsey
        end
      end

      context 'invalid information' do
        before do
          worker_profile
          post :create, params: { session: { email: worker.email } }
        end
        it 'should not worker sign in' do
          expect(response).to render_template :new
          expect(signed_in?).to be_falsey
          expect(flash).to be_present
        end
      end
    end
  end

  context 'get destroy' do
    before do
      get :destroy
    end
    it 'should worker log out' do
      expect(response).to redirect_to root_url
      expect(signed_in?).to be_falsey
    end
  end
end
