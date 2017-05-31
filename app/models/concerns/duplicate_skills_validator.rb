class DuplicateSkillsValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, _value)
    skills = record.skill_list
    unless skills.size == skills.uniq.size
      record.errors[attribute] << if record.class == WorkerProfile
                                    I18n.t('activerecord.errors.worker_skills.duplicate')
                                  else
                                    I18n.t('activerecord.errors.job_contents.duplicate_skills')
                                  end
    end
  end
end
