require 'rails_helper'

RSpec.describe SkillsController, type: :controller do
  before do
    get :autocomplete_skill, params: { term: 'ruby' }
  end

  it 'should get page' do
    expect(response).to have_http_status :success
  end
end
