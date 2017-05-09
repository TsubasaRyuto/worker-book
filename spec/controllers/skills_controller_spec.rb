# == Schema Information
#
# Table name: tags
#
#  id             :integer          not null, primary key
#  name           :string(255)
#  taggings_count :integer          default(0)
#
# Indexes
#
#  index_tags_on_name  (name) UNIQUE
#

require 'rails_helper'

RSpec.describe SkillsController, type: :controller do
  before do
    get :autocomplete_skill, params: { term: 'ruby' }
  end

  it 'should get page' do
    expect(response).to have_http_status :success
  end
end
