class PastPerformanceDuplicateValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, _value)
    url_duplicate1 = record.past_performance1 == record.past_performance2
    url_duplicate2 = record.past_performance1 == record.past_performance3
    url_duplicate3 = record.past_performance1 == record.past_performance4
    url_duplicate4 = record.past_performance2 == record.past_performance3
    url_duplicate5 = record.past_performance2 == record.past_performance4
    url_duplicate6 = if record.past_performance3.blank? || record.past_performance4.blank?
                        false
                      else
                        record.past_performance3 == record.past_performance4
                      end
    if url_duplicate1 || url_duplicate2 || url_duplicate3 || url_duplicate4 || url_duplicate5 || url_duplicate6
      record.errors[attribute] << I18n.t('activerecord.errors.worker_profile.past_performance1')
    end
  end
end
