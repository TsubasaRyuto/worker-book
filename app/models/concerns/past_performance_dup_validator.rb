class PastPerformanceDupValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, _value)
    number = %w(1 2 3 4)
    past_performance_values = number.map { |num| record.__send__("past_performance#{num}") }
    url_dup1 = past_performance_values[0] == past_performance_values[1]
    url_dup2 = past_performance_values[0] == past_performance_values[2]
    url_dup3 = past_performance_values[0] == past_performance_values[3]
    url_dup4 = past_performance_values[1] == past_performance_values[2]
    url_dup5 = past_performance_values[1] == past_performance_values[3]
    url_dup6 = record.past_performance3.blank? || record.past_performance4.blank? ? false : past_performance_values[2] == past_performance_values[3]

    past_performance_values.each do |pp|
      unless pp.blank?
        next unless url_dup1 || url_dup2 || url_dup3 || url_dup4 || url_dup5 || url_dup6
        record.errors[attribute] << I18n.t('activerecord.errors.worker_profile.past_performance_dup')
      end
    end
  end
end
