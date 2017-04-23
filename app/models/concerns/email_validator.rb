class EmailValidator < ActiveModel::EachValidator
  MAX_LENGTH_EMAIL = 100
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  def validate_each(record, attribute, value)
    if value.present?
      record.errors[attribute] << (I18n.t('activemodel.errors.messages.email') || 'is not valid') unless value =~ VALID_EMAIL_REGEX
      record.errors[attribute] << (I18n.t('errors.messages.too_long', count: MAX_LENGTH_EMAIL) || 'is too long') unless value && value.length <= MAX_LENGTH_EMAIL
    end
  end
end
