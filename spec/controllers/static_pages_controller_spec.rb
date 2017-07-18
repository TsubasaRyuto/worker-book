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

  context 'how it works' do
    it_behaves_like 'should get page' do
      let(:page) { :how_it_works }
    end
  end

  context 'how it works of worker' do
    it_behaves_like 'should get page' do
      let(:page) { :worker}
    end
  end

  context 'how it works of client' do
    it_behaves_like 'should get page' do
      let(:page) { :client }
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

  context 'client verify email' do
    context 'have a session' do
      before do
        session[:verify_email] = true
      end
      it_behaves_like 'should get page' do
        let(:page) { :client_verify_email }
      end
    end

    context 'not have a session' do
      before do
        get :client_verify_email
      end

      it 'should get page' do
        expect(response).to redirect_to root_url
      end
    end
  end

  context 'privacy policy' do
    it_behaves_like 'should get page' do
      let(:page) { :privacy_policy }
    end
  end

  context 'terms' do
    it_behaves_like 'should get page' do
      let(:page) { :terms }
    end
  end

  context 'guideline' do
    it_behaves_like 'should get page' do
      let(:page) { :guideline }
    end
  end
end
