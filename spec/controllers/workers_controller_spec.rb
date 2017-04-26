# == Schema Information
#
# Table name: workers
#
#  id                :integer          not null, primary key
#  last_name         :string(255)      not null
#  first_name        :string(255)      not null
#  username          :string(255)      not null
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

RSpec.describe WorkersController, type: :controller do
  let(:worker) { create :worker }
  let(:other_worker) { create :other_worker }
  let(:worker_profile) { create :worker_profile, worker: worker }
  context 'get new' do
    before do
      get :new
    end
    it { expect(response).to have_http_status :success }
  end

  context 'get show' do
    context 'successfull' do
      before do
        worker_profile
        get :show, params: { username: worker.username }
      end
      it { expect(response).to have_http_status :success }
    end

    context 'exception' do
      it { expect { get :show, params: { username: 'invalid' } }.to raise_error(ActiveRecord::RecordNotFound) }
    end
  end

  context 'get edit' do
    context 'successfull' do
      before do
        sign_in_as(worker)
        get :edit, params: { username: worker.username }
      end
      it { expect(response).to have_http_status :success }
    end

    context 'not signed in worker' do
      before do
        get :edit, params: { username: worker.username }
      end
      it { expect(response).to redirect_to sign_in_url }
    end

    context 'not correct worker' do
      before do
        sign_in_as(other_worker)
        get :edit, params: { username: worker.username }
      end
      it { expect(response).to redirect_to root_url }
    end
  end

  context 'get retire' do
    context 'successfull' do
      before do
        sign_in_as(worker)
        get :retire, params: { username: worker.username }
      end
      it { expect(response).to have_http_status :success }
    end

    context 'not signed in worker' do
      before do
        get :retire, params: { username: worker.username }
      end
      it { expect(response).to redirect_to sign_in_url }
    end

    context 'not correct worker' do
      before do
        sign_in_as(other_worker)
        get :retire, params: { username: worker.username }
      end
      it { expect(response).to redirect_to root_url }
    end
  end

  context 'post create' do
    let(:last_name) { Faker::Name.last_name }
    let(:first_name) { Faker::Name.first_name }
    let(:username) { 'example_worker' }
    let(:email) { 'worker@example.com' }
    let(:password) { 'foobar123' }
    let(:confirmation) { 'foobar123' }
    context 'create valid worker' do
      before do
        ApplicationMailer.deliveries.clear
      end

      it 'should create new worker' do
        expect { post :create, params: { worker: { last_name: last_name, first_name: first_name, username: username, email: email, password: password, password_confirmation: confirmation } } }.to change { Worker.count }.by(1)
        expect(response).to redirect_to worker_verify_email_url
        expect(ActionMailer::Base.deliveries.size).to eq(1)
        worker = Worker.find_by(email: 'worker@example.com')
        expect(worker.email).to eq('worker@example.com')
        expect(worker.authenticate('foobar123')).to be_truthy
      end
    end

    context 'create invalid worker' do
      shared_examples_for 'invalid worker' do
        it 'should not create worker' do
          expect { post :create, params: { worker: { last_name: last_name, first_name: first_name, username: username, email: email, password: password, password_confirmation: confirmation } } }.to change { Worker.count }.by(0)
          expect(response).to render_template(:new)
        end
      end

      context 'invalid last_name' do
        it_behaves_like 'invalid worker' do
          let(:last_name) { '' }
        end
      end

      context 'invalid first_name' do
        it_behaves_like 'invalid worker' do
          let(:first_name) { '' }
        end
      end

      context 'invalid username' do
        it_behaves_like 'invalid worker' do
          let(:username) { 'a+b' }
        end
      end

      context 'invalid email' do
        it_behaves_like 'invalid worker' do
          let(:email) { 'user@example' }
        end
      end

      context 'invalid password' do
        it_behaves_like 'invalid worker' do
          let(:password) { 'foobar' }
          let(:password_confirmation) { 'foobar' }
        end
      end

      context 'same username' do
        it_behaves_like 'invalid worker' do
          let!(:old_worker) { worker }
          let(:username) { 'example_worker' }
        end
      end

      context 'same email' do
        it_behaves_like 'invalid worker' do
          let!(:old_worker) { worker }
          let(:email) { 'worker@example.com' }
        end
      end
    end
  end

  context 'patch update' do
    context 'successfull' do
      let(:username) { 'change_username' }
      let(:email) { 'change_email@example.com' }
      context 'update valid worker' do
        before do
          sign_in_as(worker)
          patch :update, params: { username: worker.username, worker: { username: username, email: email } }
        end

        it 'should update worker info' do
          expect(response).to redirect_to worker_url(username: username)
          worker = Worker.find_by(email: 'change_email@example.com')
          expect(worker.email).to eq('change_email@example.com')
          expect(worker.username).to eq('change_username')
        end
      end
    end

    context 'faild' do
      context 'not correct worker' do
        let(:username) { 'change_username' }
        let(:email) { 'change_email@example.com' }
        before do
          sign_in_as(other_worker)
          patch :update, params: { username: worker.username, worker: { username: username, email: email } }
        end
        it { expect(response).to redirect_to root_url }
      end

      context 'not signed in' do
        let(:username) { 'change_username' }
        let(:email) { 'change_email@example.com' }
        before do
          patch :update, params: { username: worker.username, worker: { username: username, email: email } }
        end
        it { expect(response).to redirect_to sign_in_url }
      end

      context 'invalid username' do
        let(:username) { '' }
        before do
          sign_in_as(worker)
          patch :update, params: { username: worker.username, worker: { username: username } }
        end
        it { expect(response).to render_template :edit }
      end

      context 'invalid email' do
        let(:email) { '' }
        before do
          sign_in_as(worker)
          patch :update, params: { username: worker.username, worker: { email: email } }
        end
        it { expect(response).to render_template :edit }
      end
    end
  end

  context 'delete destroy' do
    context 'successfull' do
      context 'update valid worker' do
        before do
          sign_in_as(worker)
        end

        it 'should delete account' do
          expect { delete :destroy, params: { username: worker.username, password: worker.password } }.to change { Worker.count }.by(-1)
          expect(response).to redirect_to root_url
        end
      end
    end

    context 'faild' do
      context 'not correct worker' do
        before do
          sign_in_as(other_worker)
          delete :destroy, params: { username: worker.username, password: worker.password }
        end
        it { expect(response).to redirect_to root_url }
      end

      context 'not signed in' do
        before do
          delete :destroy, params: { username: worker.username, password: worker.password }
        end
        it { expect(response).to redirect_to sign_in_url }
      end

      context 'invalid password' do
        let(:password) { '' }
        before do
          sign_in_as(worker)
          delete :destroy, params: { username: worker.username, password: password }
        end
        it { expect(response).to render_template :retire }
      end
    end
  end
end
