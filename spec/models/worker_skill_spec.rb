require 'rails_helper'

RSpec.describe WorkerSkill, type: :model do

  let(:worker) { create :worker }
  let(:ruby) { Skill.find_by(name: 'Ruby').id }
  let(:php) { Skill.find_by(name: 'PHP').id }
  let(:python) { Skill.find_by(name: 'Python').id }
  let(:html) { Skill.find_by(name: 'HTML').id }
  let(:jquery) { Skill.find_by(name: 'jQuery').id }
  let(:c) { Skill.find_by(name: 'C').id }
  let(:rails) { Skill.find_by(name: 'Ruby on Rails').id }
  let(:js) { Skill.find_by(name: 'JavaScript').id }
  let(:coffee) { Skill.find_by(name: 'CoffeeScript').id }
  let(:aws) { Skill.find_by(name: 'AWS').id }
  let(:cake) { Skill.find_by(name: 'CakePHP').id }
  let(:skills) { [ruby, php, python, html, jquery] }
  let(:worker_skills) { [] }

  describe 'validate' do
    context 'successfull' do
      before do
        skills.each do |skill|
          worker_skill = worker.worker_skills.build(skill_id: skill)
          worker_skills.push(worker_skill)
        end
      end
      it { expect(worker_skills.map(&:valid?).all?).to be_truthy }
    end

    context 'faild' do
      context 'too many' do
        let(:skills) { [ruby, php, python, html, jquery, c, rails, js, coffee, aws, cake] }
        before do
          skills.each do |skill|
            worker_skill = worker.worker_skills.build(skill_id: skill)
            worker_skills.push(worker_skill)
          end
        end
        it { expect(worker_skills.map(&:valid?).all?).to be_falsey }
      end

      context 'too little' do
        let(:skills) { [ruby, php] }
        before do
          skills.each do |skill|
            worker_skill = worker.worker_skills.build(skill_id: skill)
            worker_skills.push(worker_skill)
          end
        end
        it { expect(worker_skills.map(&:valid?).all?).to be_falsey }
      end

      context 'duplicate' do
        let(:skills) { [ruby, php, python, html, html, c] }
        before do
          skills.each do |skill|
            worker_skill = worker.worker_skills.build(skill_id: skill)
            worker_skills.push(worker_skill)
          end
        end
        it { expect(worker_skills.map(&:valid?).all?).to be_falsey }
      end
    end
  end
end
