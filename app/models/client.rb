class Client < ApplicationRecord
  mount_uploader :logo, PictureUploader

  has_many :client_users, dependent: :destroy
  accepts_nested_attributes_for :client_users, allow_destroy: true

  MIN_LENGTH_NAME = 3
  MIN_LENGTH_CLIENTNAME = 5
  MAX_LENGTH_CLIENTNAME = 30
  URL_REGEX = /\A#{URI.regexp(%w(http https))}\z/
  VALID_CLIENTNAME_REGEX = /\A[a-z\d_]{5,30}\Z/

  validates :corporate_site, presence: true
  validates :corporate_site, uniqueness: { case_sensitive: false }, format: { with: URL_REGEX }, allow_blank: true
  validates :name, presence: true
  validates :name, length: { minimum: MIN_LENGTH_NAME }, allow_blank: true
  validates :clientname, presence: true
  validates :clientname, uniqueness: { case_sensitive: false }, format: { with: VALID_CLIENTNAME_REGEX }, length: { minimum: MIN_LENGTH_CLIENTNAME, maximum: MAX_LENGTH_CLIENTNAME }, allow_blank: true
  validates :location, presence: true
  validates :logo, presence: true

  def client_users_attributes=(listed_attributes)
    listed_attributes.each do |_index, attributes|
      client_user = client_users.detect { |i| i.id == attributes['id'].to_i } || client_users.build
      client_user.assign_attributes(attributes)
      client_user.activation_token = ClientUser.new_token if client_user.activation_token.nil?
      client_user.activation_digest = ClientUser.digest(client_user.activation_token)
    end
  end
end


# == Schema Information
#
# Table name: clients
#
#  id             :integer          not null, primary key
#  name           :string(255)      not null
#  corporate_site :string(255)      not null
#  clientname     :string(255)      not null
#  location       :string(255)      default("01"), not null
#  logo           :string(255)      not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
