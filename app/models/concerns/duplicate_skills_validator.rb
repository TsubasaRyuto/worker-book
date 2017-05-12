class DuplicateSkillsValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, _value)
    skills = record.skill_list
    unless skills.size == skills.uniq.size
      if record.class == WorkerProfile
        record.errors[attribute] << I18n.t('activerecord.errors.worker_skills.duplicate')
      else
        record.errors[attribute] << I18n.t('activerecord.errors.job_contents.duplicate_skills')
      end
    end
  end
end
