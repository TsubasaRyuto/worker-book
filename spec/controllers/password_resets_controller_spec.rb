require 'rails_helper'

RSpec.describe PasswordResetsController, type: :controller do
  let(:worker) { create :worker }
  let(:worker_profile) { create :worker_profile, worker: worker }
  context 'get new' do
    before do
      get :new
    end
    it 'get action' do
      expect(response).to have_http_status :success
    end
  end

  context 'get edit' do
    before do
      worker.create_reset_digest
      get :edit, params: { id: worker.reset_token, email: worker.email }
    end
    it 'edit check status code' do
      expect(response).to have_http_status :success
    end
  end

  context 'post create' do
    context 'successful' do
      before do
        ActionMailer::Base.deliveries.clear
        post :create, params: { password_reset: { email: worker.email } }
      end
      it 'shoule create when worker password reset' do
        expect(response).to redirect_to root_url
        expect(flash).to be_present
        expect(worker.reload.reset_digest).to be_present
        expect(ActionMailer::Base.deliveries.size).to eq 1
      end
    end

    context 'failed' do
      before do
        post :create, params: { password_reset: { email: 'invalid' } }
      end
      it 'should create when not worker password reset' do
        expect(response).to render_template(:new)
        expect(flash).to be_present
      end
    end
  end

  context 'patch updat' do
    context 'successful' do
      before do
        worker_profile
        worker.create_reset_digest
        patch :update, params: { id: worker.reset_token, email: worker.email, worker: { password: 'foobaz123', password_confirmation: 'foobaz123' } }
      end
      it 'should update  when worker password preset' do
        expect(response).to redirect_to worker_url(username: worker.username)
        expect(flash).to be_present
        expect(worker.reload.authenticate('foobaz123')).to be_truthy
        expect(signed_in?).to be_truthy
      end
    end

    context 'failed' do
      shared_examples_for 'invalid reset' do
        before do
          worker.create_reset_digest
          patch :update, params: { id: worker.reset_token, email: worker.email, worker: { password: password, password_confirmation: confirmation } }
        end
        it 'should not update  worker password reset' do
          expect(response).to render_template(:edit)
          expect(worker.errors).to be_truthy
        end
      end
      context 'update missed by without password' do
        it_behaves_like 'invalid reset' do
          let(:password) { '' }
          let(:confirmation) { '' }
        end
      end
      context 'update missed by invalid password' do
        it_behaves_like 'invalid reset' do
          let(:password) { 'foobaz' }
          let(:confirmation) { 'barfoo' }
        end
      end
    end
  end
end
