class NameMaxLengthValidator < ActiveModel::EachValidator
  MAX_LENGTH_NAME = 30
  def validate_each(record, attribute, value)
    if value.present?
      record.errors[attribute] << (I18n.t('errors.messages.too_long', count: MAX_LENGTH_NAME) || 'is too long') unless value && value.length <= MAX_LENGTH_NAME
    end
  end
end
