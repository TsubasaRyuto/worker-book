class EmpHistLengthValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, _value)
    number = %w(1 2 3 4)
    emp_hist_values = number.map { |num| record.__send__("employment_history#{num}") }
    emp_hist_values.each do |eh|
      if eh.present? && eh.length < 3
        record.errors[attribute] << I18n.t('activerecord.errors.worker_profile.emp_hist_length')
      end
    end
  end
end
