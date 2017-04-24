require 'rails_helper'

RSpec.describe StaticPagesController, type: :controller do
  shared_examples_for 'should get page' do
    before do
      get page
    end

    it 'should get page' do
      expect(response).to have_http_status :success
    end
  end

  context 'home' do
    it_behaves_like 'should get page' do
      let(:page) { :home }
    end
  end

  context 'sign up' do
    it_behaves_like 'should get page' do
      let(:page) { :signup }
    end
  end

  context 'worker verify email' do
    context 'have a session' do
      before do
        session[:verify_email] = true
      end
      it_behaves_like 'should get page' do
        let(:page) { :worker_verify_email }
      end
    end

    context 'not have a session' do
      before do
        get :worker_verify_email
      end

      it 'should get page' do
        expect(response).to redirect_to root_url
      end
    end
  end
end
