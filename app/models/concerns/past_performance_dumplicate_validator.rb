class PastPerformanceDumplicateValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, _value)
    url_dumplicate1 = record.past_performance1 == record.past_performance2
    url_dumplicate2 = record.past_performance1 == record.past_performance3
    url_dumplicate3 = record.past_performance1 == record.past_performance4
    url_dumplicate4 = record.past_performance2 == record.past_performance3
    url_dumplicate5 = record.past_performance2 == record.past_performance4
    url_dumplicate6 = if record.past_performance3.blank? || record.past_performance4.blank?
                        false
                      else
                        record.past_performance3 == record.past_performance4
                      end
    if url_dumplicate1 || url_dumplicate2 || url_dumplicate3 || url_dumplicate4 || url_dumplicate5 || url_dumplicate6
      record.errors[attribute] << I18n.t('activerecord.errors.worker_profile.past_performance1')
    end
  end
end
