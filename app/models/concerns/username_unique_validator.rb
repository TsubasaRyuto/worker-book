class UsernameUniqueValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    # usernameは一意であるので、一つしかマッチしないため目的のユーザーをfirstで取得可能
    search_worker = Worker.where(username: value).first
    search_client_user = ClientUser.where(username: value).first

    worker_requirement = search_worker.present? && search_worker != record
    client_requirement = search_client_user.present? && search_client_user != record
    if value.present? && worker_requirement || client_requirement
      record.errors[attribute] << (I18n.t('activemodel.errors.messages.username_unique') || ' already exists')
    end
  end
end
