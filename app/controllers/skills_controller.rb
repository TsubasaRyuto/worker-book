class SkillsController < ApplicationController
  def autocomplete_skill
    skills = Skill.autocomplete(params[:term]).pluck(:name)
    render json: skills
  end
end
