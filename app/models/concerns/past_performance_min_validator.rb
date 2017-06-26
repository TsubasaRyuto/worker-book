class PastPerformanceMinValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, _value)
    number = %w(1 2 3 4)
    past_performance_values = number.map { |num| record.__send__("past_performance#{num}") }
    if past_performance_values[0].blank? && past_performance_values[1].blank?
      record.errors[attribute] << I18n.t('activerecord.errors.worker_profile.past_performance_min')
    end
  end
end
