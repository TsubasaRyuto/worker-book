class ClientProfile < ApplicationRecord
  mount_uploader :logo, ProfilePictureUploader

  self.table_name = 'client_profiles'
  self.primary_key = :id
  belongs_to :client, foreign_key: 'id'
  before_create { self.id = self.client.id }

  URL_REGEX = /\A#{URI.regexp(%w(http https))}\z/

  validates :id, uniqueness: true
  validates :corporate_site, presence: true
  validates :corporate_site, uniqueness: { case_sensitive: false }, format: { with: URL_REGEX }, allow_blank: true
  validates :logo, presence: true
end


# == Schema Information
#
# Table name: client_profiles
#
#  id             :integer          not null, primary key
#  corporate_site :string(255)      not null
#  logo           :string(255)      not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
# Indexes
#
#  index_client_profiles_on_id  (id) UNIQUE
#
