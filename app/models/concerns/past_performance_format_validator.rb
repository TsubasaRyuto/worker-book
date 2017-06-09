class PastPerformanceFormatValidator < ActiveModel::EachValidator
  URL_REGEX = /\A#{URI.regexp(%w(http https))}\z/
  def validate_each(record, attribute, _value)
    number = %w(1 2 3 4)
    past_performance_values = number.map { |num| record.__send__("past_performance#{num}") }
    past_performance_values.each do |pp|
      next unless pp.present?
      unless URL_REGEX === pp
        record.errors[attribute] << I18n.t('activerecord.errors.worker_profile.past_performance_format')
      end
    end
  end
end
