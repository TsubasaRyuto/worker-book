class EmpHistPresenceValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, _value)
    number = %w(1 2 3 4)
    emp_hist_values = number.map { |num| record.__send__("employment_history#{num}") }
    if emp_hist_values[0].blank?
      record.errors[attribute] << I18n.t('activerecord.errors.worker_profile.emp_hist_presence')
    end
  end
end
