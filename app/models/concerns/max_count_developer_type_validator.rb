class MaxCountDeveloperTypeValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, _value)
    type_name = %w(
      web_developer mobile_developer game_developer desktop_developer
      ai_developer qa_testing web_mobile_desiner project_maneger other
    )
    type_values = type_name.map { |name| record.__send__("type_#{name}") }
    unless type_values.count(true) <= 4
      record.errors[attribute] << I18n.t('activerecord.errors.worker_profile.max_count_type')
    end
  end
end
