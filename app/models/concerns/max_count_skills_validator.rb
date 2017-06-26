class MaxCountSkillsValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, _value)
    if record.skill_list.count >= 10
      record.errors[attribute] << if record.class == WorkerProfile
                                    I18n.t('activerecord.errors.worker_skills.too_many')
                                  else
                                    I18n.t('activerecord.errors.job_contents.max_count_skills')
                                  end
    end
  end
end
