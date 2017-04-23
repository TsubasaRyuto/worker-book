class EmailUniqueValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    # emailは一意であるので、一つしかマッチしないため目的のユーザーをfirstで取得可能
    search_worker = Worker.where(email: value).first
    search_client = Client.where(email: value).first

    worker_requirement = search_worker.present? && search_worker != record
    client_requirement = search_client.present? && search_client != record
    if value.present? && worker_requirement || client_requirement
      record.errors[attribute] << (I18n.t('activemodel.errors.messages.email_unique') || ' already exists')
    end
  end
end
