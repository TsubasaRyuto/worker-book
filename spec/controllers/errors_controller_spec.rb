require 'rails_helper'

RSpec.describe ErrorsController, type: :controller do

  context 'GET #error_404' do
    it 'returns http success' do
      get :error_404
      expect(response).to have_http_status(404)
    end
  end

  context 'GET #error_500' do
    it 'returns http success' do
      get :error_500
      expect(response).to have_http_status(500)
    end
  end
end
