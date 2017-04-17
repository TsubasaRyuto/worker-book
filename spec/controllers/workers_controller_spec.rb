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
#  admin             :boolean          default(FALSE), not null
#  activation_digest :string(255)
#  activated         :boolean          default(FALSE), not null
#  activated_at      :datetime
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#

require 'rails_helper'

RSpec.describe WorkersController, type: :controller do
  let(:worker) { create :worker }
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

  context 'create' do
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

      it 'create new worker' do
        expect { post :create, params: { worker: { last_name: last_name, first_name: first_name, username: username, email: email, password: password, password_confirmation: confirmation } } }.to change { Worker.count }.by(1)
        expect(response).to redirect_to verify_email_url
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
end
