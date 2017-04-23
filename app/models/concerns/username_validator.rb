class UsernameValidator < ActiveModel::EachValidator
  MAX_LENGTH_NAME = 30
  MIN_LENGTH_NAME = 5
  VALID_USERNAME_REGEX = /\A[a-z\d_]{5,30}\Z/

  def validate_each(record, attribute, value)
    if value.present?
      record.errors[attribute] << (I18n.t('activemodel.errors.messages.username') || 'is not an username') unless value =~ VALID_USERNAME_REGEX
      record.errors[attribute] << (I18n.t('errors.messages.too_short', count: MIN_LENGTH_NAME) || 'is too short') unless value && value.length >= MIN_LENGTH_NAME
      record.errors[attribute] << (I18n.t('errors.messages.too_long', count: MAX_LENGTH_NAME) || 'is too long') unless value && value.length <= MAX_LENGTH_NAME
    end
  end
end
