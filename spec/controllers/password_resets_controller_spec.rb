require 'rails_helper'

RSpec.describe PasswordResetsController, type: :controller do
  context 'get new' do
    before do
      get :new
    end
    it 'get action' do
      expect(response).to have_http_status :success
    end
  end

  context 'get edit' do
    shared_examples_for 'redirect edit password' do
      before do
        user.create_reset_digest
        get :edit, params: { id: user.reset_token, email: user.email }
      end
      it { expect(response).to have_http_status :success }
    end

    context 'worker' do
      it_behaves_like 'redirect edit password' do
        let(:user) { create :worker }
      end
    end

    context 'client' do
      it_behaves_like 'redirect edit password' do
        let(:client) { create :client }
        let(:user) { create :client_user, client: client }
      end
    end
  end

  context 'post create' do
    shared_examples_for'send email of user password reset link' do
      context 'success' do
        before do
          ActionMailer::Base.deliveries.clear
          post :create, params: { password_reset: { email: user.email } }
        end
        it 'shoule create when user password reset' do
          expect(response).to redirect_to root_url
          expect(flash).to be_present
          expect(user.reload.reset_digest).to be_present
          expect(ActionMailer::Base.deliveries.size).to eq 1
        end
      end

      context 'failed' do
        before do
          post :create, params: { password_reset: { email: 'invalid' } }
        end
        it 'should create when not user password reset' do
          expect(response).to render_template(:new)
          expect(flash).to be_present
        end
      end
    end

    context 'worker' do
      it_behaves_like 'send email of user password reset link' do
        let(:user) { create :worker }
      end
    end

    context 'client' do
      it_behaves_like 'send email of user password reset link' do
        let(:client) { create :client }
        let(:user) { create :client_user, client: client }
      end
    end
  end

  context 'patch updat' do
    shared_examples_for 'update user password' do
      context 'successful' do
        before do
          user_profile
          user.create_reset_digest
          if user.class == Worker
            patch :update, params: { id: user.reset_token, email: user.email, worker: { password: 'foobaz123', password_confirmation: 'foobaz123' } }
          elsif user.class == ClientUser
            patch :update, params: { id: user.reset_token, email: user.email, client_user: { password: 'foobaz123', password_confirmation: 'foobaz123' } }
          end
        end
        it 'should update  when user password preset' do
          expect(response).to redirect_to redirect_url
          expect(flash).to be_present
          expect(user.reload.authenticate('foobaz123')).to be_truthy
          expect(signed_in?).to be_truthy
        end
      end

      context 'failed' do
        shared_examples_for 'invalid reset' do
          before do
            user.create_reset_digest
            if user.class == Worker
              patch :update, params: { id: user.reset_token, email: user.email, worker: { password: password, password_confirmation: confirmation } }
            elsif user.class == ClientUser
              patch :update, params: { id: user.reset_token, email: user.email, client_user: { password: password, password_confirmation: confirmation } }
            end
          end
          it 'should not update  user password reset' do
            expect(response).to render_template(:edit)
            expect(user.errors).to be_truthy
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

    context 'worker' do
      it_behaves_like 'update user password' do
        let(:user) { create :worker }
        let(:user_profile) { create :worker_profile, worker: user }
        let(:redirect_url) { "/worker/#{user.username}" }
      end
    end

    context 'client' do
      it_behaves_like 'update user password' do
        let(:user_profile) { create :client }
        let(:user) { create :client_user, client: user_profile }
        let(:redirect_url) { "/client/#{user_profile.clientname}" }
      end
    end
  end
end
