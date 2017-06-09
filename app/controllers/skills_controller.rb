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

class SkillsController < ApplicationController
  def autocomplete_skill
    skills = Skill.autocomplete(params[:term]).pluck(:name)
    render json: skills
  end
end
