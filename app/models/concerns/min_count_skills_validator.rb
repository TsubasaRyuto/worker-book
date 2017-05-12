class MinCountSkillsValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, _value)
    if record.skill_list.count < 5
      record.errors[attribute] << I18n.t('activerecord.errors.worker_skills.too_little')
    end
  end
end
