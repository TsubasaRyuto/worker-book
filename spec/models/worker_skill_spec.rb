require 'rails_helper'

RSpec.describe WorkerSkill, type: :model do

  let(:worker) { create :worker }
  let(:ruby) { SkillLanguage.find_by(name: 'Ruby').id }
  let(:php) { SkillLanguage.find_by(name: 'PHP').id }
  let(:python) { SkillLanguage.find_by(name: 'Python').id }
  let(:html) { SkillLanguage.find_by(name: 'HTML').id }
  let(:jquery) { SkillLanguage.find_by(name: 'jQuery').id }
  let(:c) { SkillLanguage.find_by(name: 'C').id }
  let(:rails) { SkillLanguage.find_by(name: 'Ruby on Rails').id }
  let(:js) { SkillLanguage.find_by(name: 'JavaScript').id }
  let(:coffee) { SkillLanguage.find_by(name: 'CoffeeScript').id }
  let(:aws) { SkillLanguage.find_by(name: 'AWS').id }
  let(:cake) { SkillLanguage.find_by(name: 'CakePHP').id }
  let(:skill_languages) { [ruby, php, python, html, jquery] }
  let(:worker_skill_languages) { [] }

  describe 'validate' do
    context 'successfull' do
      before do
        skill_languages.each do |skill|
          worker_skill = worker.worker_skills.build(skill_language_id: skill)
          worker_skill_languages.push(worker_skill)
        end
      end
      it { expect(worker_skill_languages.map(&:valid?).all?).to be_truthy }
    end

    context 'faild' do
      context 'too many' do
        let(:skill_languages) { [ruby, php, python, html, jquery, c, rails, js, coffee, aws, cake] }
        before do
          skill_languages.each do |skill|
            worker_skill = worker.worker_skills.build(skill_language_id: skill)
            worker_skill_languages.push(worker_skill)
          end
        end
        it { expect(worker_skill_languages.map(&:valid?).all?).to be_falsey }
      end

      context 'too little' do
        let(:skill_languages) { [ruby, php] }
        before do
          skill_languages.each do |skill|
            worker_skill = worker.worker_skills.build(skill_language_id: skill)
            worker_skill_languages.push(worker_skill)
          end
        end
        it { expect(worker_skill_languages.map(&:valid?).all?).to be_falsey }
      end

      context 'duplicate' do
        let(:skill_languages) { [ruby, php, python, html, html, c] }
        before do
          skill_languages.each do |skill|
            worker_skill = worker.worker_skills.build(skill_language_id: skill)
            worker_skill_languages.push(worker_skill)
          end
        end
        it { expect(worker_skill_languages.map(&:valid?).all?).to be_falsey }
      end
    end
  end
end
